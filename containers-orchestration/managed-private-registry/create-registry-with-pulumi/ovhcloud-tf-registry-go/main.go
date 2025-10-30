package main

import (
	"github.com/pulumi/pulumi-terraform-provider/sdks/go/ovh"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"
	"github.com/pulumiverse/pulumi-harbor/sdk/v3/go/harbor"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {

		serviceName := config.Require(ctx, "serviceName")

		// Initiate the configuration of the registry
		regcap, err := ovh.GetCloudProjectCapabilitiesContainerregistryFilter(ctx, &ovh.GetCloudProjectCapabilitiesContainerregistryFilterArgs{
			ServiceName: &serviceName,
			PlanName:    "SMALL",
			Region:      "GRA",
		}, nil)
		if err != nil {
			return err
		}

		// Deploy a new Managed private registry
		myRegistry, err := ovh.NewCloudProjectContainerregistry(ctx, "my-registry", &ovh.CloudProjectContainerregistryArgs{
			ServiceName: pulumi.String(*regcap.ServiceName),
			PlanId:      pulumi.String(regcap.Id),
			Region:      pulumi.String(regcap.Region),
		})
		if err != nil {
			return err
		}

		// Create a User
		myRegistryUser, err := ovh.NewCloudProjectContainerregistryUser(ctx, "user", &ovh.CloudProjectContainerregistryUserArgs{
			ServiceName: pulumi.String(*regcap.ServiceName),
			RegistryId:  myRegistry.ID(),
			Email:       pulumi.String("myuser@ovh.com"),
			Login:       pulumi.String("myuser"),
		})
		if err != nil {
			return err
		}

		// Add as an output registry information
		ctx.Export("registryID", myRegistry.ID())
		ctx.Export("registryName", myRegistry.Name)
		ctx.Export("registryURL", myRegistry.Url)
		ctx.Export("registryVersion", myRegistry.Version)
		ctx.Export("registryUser", myRegistryUser.User)
		ctx.Export("registryPassword", myRegistryUser.Password)

		// Use the created registry to initiate the harbor provider
		harborProvider, err := harbor.NewProvider(ctx, "harbor", &harbor.ProviderArgs{
			Username: myRegistryUser.User,
			Password: myRegistryUser.Password,
			Url:      myRegistry.Url,
		}, pulumi.DependsOn([]pulumi.Resource{myRegistry, myRegistryUser}))
		if err != nil {
			return err
		}

		// Create a public project in your harbor registry
		project, err := harbor.NewProject(ctx, "project", &harbor.ProjectArgs{
			Name:         pulumi.String("my-new-project"),
			Public:       pulumi.Bool(true),
			ForceDestroy: pulumi.Bool(true), // force_destroy set to true in order to be allowed to destroy a project event in it's not empty
		}, pulumi.Provider(harborProvider))
		if err != nil {
			return err
		}

		ctx.Export("project", project.Name)

		return nil
	})
}

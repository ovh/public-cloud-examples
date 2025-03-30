// Code generated by pulumi-language-go DO NOT EDIT.
// *** WARNING: Do not edit by hand unless you're certain you know what you are doing! ***

package ovh

import (
	"context"
	"reflect"

	"errors"
	"github.com/pulumi/pulumi-terraform-provider/sdks/go/ovh/internal"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

type CloudProjectContainerregistryOidc struct {
	pulumi.CustomResourceState

	DeleteUsers      pulumi.BoolPtrOutput                               `pulumi:"deleteUsers"`
	OidcAdminGroup   pulumi.StringPtrOutput                             `pulumi:"oidcAdminGroup"`
	OidcAutoOnboard  pulumi.BoolPtrOutput                               `pulumi:"oidcAutoOnboard"`
	OidcClientId     pulumi.StringOutput                                `pulumi:"oidcClientId"`
	OidcClientSecret pulumi.StringOutput                                `pulumi:"oidcClientSecret"`
	OidcEndpoint     pulumi.StringOutput                                `pulumi:"oidcEndpoint"`
	OidcGroupsClaim  pulumi.StringPtrOutput                             `pulumi:"oidcGroupsClaim"`
	OidcName         pulumi.StringOutput                                `pulumi:"oidcName"`
	OidcScope        pulumi.StringOutput                                `pulumi:"oidcScope"`
	OidcUserClaim    pulumi.StringPtrOutput                             `pulumi:"oidcUserClaim"`
	OidcVerifyCert   pulumi.BoolPtrOutput                               `pulumi:"oidcVerifyCert"`
	RegistryId       pulumi.StringOutput                                `pulumi:"registryId"`
	ServiceName      pulumi.StringPtrOutput                             `pulumi:"serviceName"`
	Timeouts         CloudProjectContainerregistryOidcTimeoutsPtrOutput `pulumi:"timeouts"`
}

// NewCloudProjectContainerregistryOidc registers a new resource with the given unique name, arguments, and options.
func NewCloudProjectContainerregistryOidc(ctx *pulumi.Context,
	name string, args *CloudProjectContainerregistryOidcArgs, opts ...pulumi.ResourceOption) (*CloudProjectContainerregistryOidc, error) {
	if args == nil {
		return nil, errors.New("missing one or more required arguments")
	}

	if args.OidcClientId == nil {
		return nil, errors.New("invalid value for required argument 'OidcClientId'")
	}
	if args.OidcClientSecret == nil {
		return nil, errors.New("invalid value for required argument 'OidcClientSecret'")
	}
	if args.OidcEndpoint == nil {
		return nil, errors.New("invalid value for required argument 'OidcEndpoint'")
	}
	if args.OidcName == nil {
		return nil, errors.New("invalid value for required argument 'OidcName'")
	}
	if args.OidcScope == nil {
		return nil, errors.New("invalid value for required argument 'OidcScope'")
	}
	if args.RegistryId == nil {
		return nil, errors.New("invalid value for required argument 'RegistryId'")
	}
	if args.OidcClientSecret != nil {
		args.OidcClientSecret = pulumi.ToSecret(args.OidcClientSecret).(pulumi.StringInput)
	}
	secrets := pulumi.AdditionalSecretOutputs([]string{
		"oidcClientSecret",
	})
	opts = append(opts, secrets)
	opts = internal.PkgResourceDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var resource CloudProjectContainerregistryOidc
	err = ctx.RegisterPackageResource("ovh:index/cloudProjectContainerregistryOidc:CloudProjectContainerregistryOidc", name, args, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// GetCloudProjectContainerregistryOidc gets an existing CloudProjectContainerregistryOidc resource's state with the given name, ID, and optional
// state properties that are used to uniquely qualify the lookup (nil if not required).
func GetCloudProjectContainerregistryOidc(ctx *pulumi.Context,
	name string, id pulumi.IDInput, state *CloudProjectContainerregistryOidcState, opts ...pulumi.ResourceOption) (*CloudProjectContainerregistryOidc, error) {
	var resource CloudProjectContainerregistryOidc
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	err = ctx.ReadPackageResource("ovh:index/cloudProjectContainerregistryOidc:CloudProjectContainerregistryOidc", name, id, state, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// Input properties used for looking up and filtering CloudProjectContainerregistryOidc resources.
type cloudProjectContainerregistryOidcState struct {
	DeleteUsers      *bool                                      `pulumi:"deleteUsers"`
	OidcAdminGroup   *string                                    `pulumi:"oidcAdminGroup"`
	OidcAutoOnboard  *bool                                      `pulumi:"oidcAutoOnboard"`
	OidcClientId     *string                                    `pulumi:"oidcClientId"`
	OidcClientSecret *string                                    `pulumi:"oidcClientSecret"`
	OidcEndpoint     *string                                    `pulumi:"oidcEndpoint"`
	OidcGroupsClaim  *string                                    `pulumi:"oidcGroupsClaim"`
	OidcName         *string                                    `pulumi:"oidcName"`
	OidcScope        *string                                    `pulumi:"oidcScope"`
	OidcUserClaim    *string                                    `pulumi:"oidcUserClaim"`
	OidcVerifyCert   *bool                                      `pulumi:"oidcVerifyCert"`
	RegistryId       *string                                    `pulumi:"registryId"`
	ServiceName      *string                                    `pulumi:"serviceName"`
	Timeouts         *CloudProjectContainerregistryOidcTimeouts `pulumi:"timeouts"`
}

type CloudProjectContainerregistryOidcState struct {
	DeleteUsers      pulumi.BoolPtrInput
	OidcAdminGroup   pulumi.StringPtrInput
	OidcAutoOnboard  pulumi.BoolPtrInput
	OidcClientId     pulumi.StringPtrInput
	OidcClientSecret pulumi.StringPtrInput
	OidcEndpoint     pulumi.StringPtrInput
	OidcGroupsClaim  pulumi.StringPtrInput
	OidcName         pulumi.StringPtrInput
	OidcScope        pulumi.StringPtrInput
	OidcUserClaim    pulumi.StringPtrInput
	OidcVerifyCert   pulumi.BoolPtrInput
	RegistryId       pulumi.StringPtrInput
	ServiceName      pulumi.StringPtrInput
	Timeouts         CloudProjectContainerregistryOidcTimeoutsPtrInput
}

func (CloudProjectContainerregistryOidcState) ElementType() reflect.Type {
	return reflect.TypeOf((*cloudProjectContainerregistryOidcState)(nil)).Elem()
}

type cloudProjectContainerregistryOidcArgs struct {
	DeleteUsers      *bool                                      `pulumi:"deleteUsers"`
	OidcAdminGroup   *string                                    `pulumi:"oidcAdminGroup"`
	OidcAutoOnboard  *bool                                      `pulumi:"oidcAutoOnboard"`
	OidcClientId     string                                     `pulumi:"oidcClientId"`
	OidcClientSecret string                                     `pulumi:"oidcClientSecret"`
	OidcEndpoint     string                                     `pulumi:"oidcEndpoint"`
	OidcGroupsClaim  *string                                    `pulumi:"oidcGroupsClaim"`
	OidcName         string                                     `pulumi:"oidcName"`
	OidcScope        string                                     `pulumi:"oidcScope"`
	OidcUserClaim    *string                                    `pulumi:"oidcUserClaim"`
	OidcVerifyCert   *bool                                      `pulumi:"oidcVerifyCert"`
	RegistryId       string                                     `pulumi:"registryId"`
	ServiceName      *string                                    `pulumi:"serviceName"`
	Timeouts         *CloudProjectContainerregistryOidcTimeouts `pulumi:"timeouts"`
}

// The set of arguments for constructing a CloudProjectContainerregistryOidc resource.
type CloudProjectContainerregistryOidcArgs struct {
	DeleteUsers      pulumi.BoolPtrInput
	OidcAdminGroup   pulumi.StringPtrInput
	OidcAutoOnboard  pulumi.BoolPtrInput
	OidcClientId     pulumi.StringInput
	OidcClientSecret pulumi.StringInput
	OidcEndpoint     pulumi.StringInput
	OidcGroupsClaim  pulumi.StringPtrInput
	OidcName         pulumi.StringInput
	OidcScope        pulumi.StringInput
	OidcUserClaim    pulumi.StringPtrInput
	OidcVerifyCert   pulumi.BoolPtrInput
	RegistryId       pulumi.StringInput
	ServiceName      pulumi.StringPtrInput
	Timeouts         CloudProjectContainerregistryOidcTimeoutsPtrInput
}

func (CloudProjectContainerregistryOidcArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*cloudProjectContainerregistryOidcArgs)(nil)).Elem()
}

type CloudProjectContainerregistryOidcInput interface {
	pulumi.Input

	ToCloudProjectContainerregistryOidcOutput() CloudProjectContainerregistryOidcOutput
	ToCloudProjectContainerregistryOidcOutputWithContext(ctx context.Context) CloudProjectContainerregistryOidcOutput
}

func (*CloudProjectContainerregistryOidc) ElementType() reflect.Type {
	return reflect.TypeOf((**CloudProjectContainerregistryOidc)(nil)).Elem()
}

func (i *CloudProjectContainerregistryOidc) ToCloudProjectContainerregistryOidcOutput() CloudProjectContainerregistryOidcOutput {
	return i.ToCloudProjectContainerregistryOidcOutputWithContext(context.Background())
}

func (i *CloudProjectContainerregistryOidc) ToCloudProjectContainerregistryOidcOutputWithContext(ctx context.Context) CloudProjectContainerregistryOidcOutput {
	return pulumi.ToOutputWithContext(ctx, i).(CloudProjectContainerregistryOidcOutput)
}

type CloudProjectContainerregistryOidcOutput struct{ *pulumi.OutputState }

func (CloudProjectContainerregistryOidcOutput) ElementType() reflect.Type {
	return reflect.TypeOf((**CloudProjectContainerregistryOidc)(nil)).Elem()
}

func (o CloudProjectContainerregistryOidcOutput) ToCloudProjectContainerregistryOidcOutput() CloudProjectContainerregistryOidcOutput {
	return o
}

func (o CloudProjectContainerregistryOidcOutput) ToCloudProjectContainerregistryOidcOutputWithContext(ctx context.Context) CloudProjectContainerregistryOidcOutput {
	return o
}

func (o CloudProjectContainerregistryOidcOutput) DeleteUsers() pulumi.BoolPtrOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.BoolPtrOutput { return v.DeleteUsers }).(pulumi.BoolPtrOutput)
}

func (o CloudProjectContainerregistryOidcOutput) OidcAdminGroup() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.StringPtrOutput { return v.OidcAdminGroup }).(pulumi.StringPtrOutput)
}

func (o CloudProjectContainerregistryOidcOutput) OidcAutoOnboard() pulumi.BoolPtrOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.BoolPtrOutput { return v.OidcAutoOnboard }).(pulumi.BoolPtrOutput)
}

func (o CloudProjectContainerregistryOidcOutput) OidcClientId() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.StringOutput { return v.OidcClientId }).(pulumi.StringOutput)
}

func (o CloudProjectContainerregistryOidcOutput) OidcClientSecret() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.StringOutput { return v.OidcClientSecret }).(pulumi.StringOutput)
}

func (o CloudProjectContainerregistryOidcOutput) OidcEndpoint() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.StringOutput { return v.OidcEndpoint }).(pulumi.StringOutput)
}

func (o CloudProjectContainerregistryOidcOutput) OidcGroupsClaim() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.StringPtrOutput { return v.OidcGroupsClaim }).(pulumi.StringPtrOutput)
}

func (o CloudProjectContainerregistryOidcOutput) OidcName() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.StringOutput { return v.OidcName }).(pulumi.StringOutput)
}

func (o CloudProjectContainerregistryOidcOutput) OidcScope() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.StringOutput { return v.OidcScope }).(pulumi.StringOutput)
}

func (o CloudProjectContainerregistryOidcOutput) OidcUserClaim() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.StringPtrOutput { return v.OidcUserClaim }).(pulumi.StringPtrOutput)
}

func (o CloudProjectContainerregistryOidcOutput) OidcVerifyCert() pulumi.BoolPtrOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.BoolPtrOutput { return v.OidcVerifyCert }).(pulumi.BoolPtrOutput)
}

func (o CloudProjectContainerregistryOidcOutput) RegistryId() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.StringOutput { return v.RegistryId }).(pulumi.StringOutput)
}

func (o CloudProjectContainerregistryOidcOutput) ServiceName() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) pulumi.StringPtrOutput { return v.ServiceName }).(pulumi.StringPtrOutput)
}

func (o CloudProjectContainerregistryOidcOutput) Timeouts() CloudProjectContainerregistryOidcTimeoutsPtrOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryOidc) CloudProjectContainerregistryOidcTimeoutsPtrOutput {
		return v.Timeouts
	}).(CloudProjectContainerregistryOidcTimeoutsPtrOutput)
}

func init() {
	pulumi.RegisterInputType(reflect.TypeOf((*CloudProjectContainerregistryOidcInput)(nil)).Elem(), &CloudProjectContainerregistryOidc{})
	pulumi.RegisterOutputType(CloudProjectContainerregistryOidcOutput{})
}

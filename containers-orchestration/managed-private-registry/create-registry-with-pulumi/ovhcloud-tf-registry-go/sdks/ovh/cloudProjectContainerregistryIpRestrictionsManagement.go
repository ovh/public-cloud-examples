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

type CloudProjectContainerregistryIpRestrictionsManagement struct {
	pulumi.CustomResourceState

	// List your IP restrictions applied on artifact manager component
	IpRestrictions pulumi.StringMapArrayOutput `pulumi:"ipRestrictions"`
	// RegistryID
	RegistryId pulumi.StringOutput `pulumi:"registryId"`
	// Service name
	ServiceName pulumi.StringPtrOutput `pulumi:"serviceName"`
}

// NewCloudProjectContainerregistryIpRestrictionsManagement registers a new resource with the given unique name, arguments, and options.
func NewCloudProjectContainerregistryIpRestrictionsManagement(ctx *pulumi.Context,
	name string, args *CloudProjectContainerregistryIpRestrictionsManagementArgs, opts ...pulumi.ResourceOption) (*CloudProjectContainerregistryIpRestrictionsManagement, error) {
	if args == nil {
		return nil, errors.New("missing one or more required arguments")
	}

	if args.IpRestrictions == nil {
		return nil, errors.New("invalid value for required argument 'IpRestrictions'")
	}
	if args.RegistryId == nil {
		return nil, errors.New("invalid value for required argument 'RegistryId'")
	}
	opts = internal.PkgResourceDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var resource CloudProjectContainerregistryIpRestrictionsManagement
	err = ctx.RegisterPackageResource("ovh:index/cloudProjectContainerregistryIpRestrictionsManagement:CloudProjectContainerregistryIpRestrictionsManagement", name, args, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// GetCloudProjectContainerregistryIpRestrictionsManagement gets an existing CloudProjectContainerregistryIpRestrictionsManagement resource's state with the given name, ID, and optional
// state properties that are used to uniquely qualify the lookup (nil if not required).
func GetCloudProjectContainerregistryIpRestrictionsManagement(ctx *pulumi.Context,
	name string, id pulumi.IDInput, state *CloudProjectContainerregistryIpRestrictionsManagementState, opts ...pulumi.ResourceOption) (*CloudProjectContainerregistryIpRestrictionsManagement, error) {
	var resource CloudProjectContainerregistryIpRestrictionsManagement
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	err = ctx.ReadPackageResource("ovh:index/cloudProjectContainerregistryIpRestrictionsManagement:CloudProjectContainerregistryIpRestrictionsManagement", name, id, state, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// Input properties used for looking up and filtering CloudProjectContainerregistryIpRestrictionsManagement resources.
type cloudProjectContainerregistryIpRestrictionsManagementState struct {
	// List your IP restrictions applied on artifact manager component
	IpRestrictions []map[string]string `pulumi:"ipRestrictions"`
	// RegistryID
	RegistryId *string `pulumi:"registryId"`
	// Service name
	ServiceName *string `pulumi:"serviceName"`
}

type CloudProjectContainerregistryIpRestrictionsManagementState struct {
	// List your IP restrictions applied on artifact manager component
	IpRestrictions pulumi.StringMapArrayInput
	// RegistryID
	RegistryId pulumi.StringPtrInput
	// Service name
	ServiceName pulumi.StringPtrInput
}

func (CloudProjectContainerregistryIpRestrictionsManagementState) ElementType() reflect.Type {
	return reflect.TypeOf((*cloudProjectContainerregistryIpRestrictionsManagementState)(nil)).Elem()
}

type cloudProjectContainerregistryIpRestrictionsManagementArgs struct {
	// List your IP restrictions applied on artifact manager component
	IpRestrictions []map[string]string `pulumi:"ipRestrictions"`
	// RegistryID
	RegistryId string `pulumi:"registryId"`
	// Service name
	ServiceName *string `pulumi:"serviceName"`
}

// The set of arguments for constructing a CloudProjectContainerregistryIpRestrictionsManagement resource.
type CloudProjectContainerregistryIpRestrictionsManagementArgs struct {
	// List your IP restrictions applied on artifact manager component
	IpRestrictions pulumi.StringMapArrayInput
	// RegistryID
	RegistryId pulumi.StringInput
	// Service name
	ServiceName pulumi.StringPtrInput
}

func (CloudProjectContainerregistryIpRestrictionsManagementArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*cloudProjectContainerregistryIpRestrictionsManagementArgs)(nil)).Elem()
}

type CloudProjectContainerregistryIpRestrictionsManagementInput interface {
	pulumi.Input

	ToCloudProjectContainerregistryIpRestrictionsManagementOutput() CloudProjectContainerregistryIpRestrictionsManagementOutput
	ToCloudProjectContainerregistryIpRestrictionsManagementOutputWithContext(ctx context.Context) CloudProjectContainerregistryIpRestrictionsManagementOutput
}

func (*CloudProjectContainerregistryIpRestrictionsManagement) ElementType() reflect.Type {
	return reflect.TypeOf((**CloudProjectContainerregistryIpRestrictionsManagement)(nil)).Elem()
}

func (i *CloudProjectContainerregistryIpRestrictionsManagement) ToCloudProjectContainerregistryIpRestrictionsManagementOutput() CloudProjectContainerregistryIpRestrictionsManagementOutput {
	return i.ToCloudProjectContainerregistryIpRestrictionsManagementOutputWithContext(context.Background())
}

func (i *CloudProjectContainerregistryIpRestrictionsManagement) ToCloudProjectContainerregistryIpRestrictionsManagementOutputWithContext(ctx context.Context) CloudProjectContainerregistryIpRestrictionsManagementOutput {
	return pulumi.ToOutputWithContext(ctx, i).(CloudProjectContainerregistryIpRestrictionsManagementOutput)
}

type CloudProjectContainerregistryIpRestrictionsManagementOutput struct{ *pulumi.OutputState }

func (CloudProjectContainerregistryIpRestrictionsManagementOutput) ElementType() reflect.Type {
	return reflect.TypeOf((**CloudProjectContainerregistryIpRestrictionsManagement)(nil)).Elem()
}

func (o CloudProjectContainerregistryIpRestrictionsManagementOutput) ToCloudProjectContainerregistryIpRestrictionsManagementOutput() CloudProjectContainerregistryIpRestrictionsManagementOutput {
	return o
}

func (o CloudProjectContainerregistryIpRestrictionsManagementOutput) ToCloudProjectContainerregistryIpRestrictionsManagementOutputWithContext(ctx context.Context) CloudProjectContainerregistryIpRestrictionsManagementOutput {
	return o
}

// List your IP restrictions applied on artifact manager component
func (o CloudProjectContainerregistryIpRestrictionsManagementOutput) IpRestrictions() pulumi.StringMapArrayOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryIpRestrictionsManagement) pulumi.StringMapArrayOutput {
		return v.IpRestrictions
	}).(pulumi.StringMapArrayOutput)
}

// RegistryID
func (o CloudProjectContainerregistryIpRestrictionsManagementOutput) RegistryId() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryIpRestrictionsManagement) pulumi.StringOutput {
		return v.RegistryId
	}).(pulumi.StringOutput)
}

// Service name
func (o CloudProjectContainerregistryIpRestrictionsManagementOutput) ServiceName() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *CloudProjectContainerregistryIpRestrictionsManagement) pulumi.StringPtrOutput {
		return v.ServiceName
	}).(pulumi.StringPtrOutput)
}

func init() {
	pulumi.RegisterInputType(reflect.TypeOf((*CloudProjectContainerregistryIpRestrictionsManagementInput)(nil)).Elem(), &CloudProjectContainerregistryIpRestrictionsManagement{})
	pulumi.RegisterOutputType(CloudProjectContainerregistryIpRestrictionsManagementOutput{})
}

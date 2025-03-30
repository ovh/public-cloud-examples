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

type CloudProjectUserS3Policy struct {
	pulumi.CustomResourceState

	// The policy document. This is a JSON formatted string.
	Policy pulumi.StringOutput `pulumi:"policy"`
	// Service name of the resource representing the ID of the cloud project.
	ServiceName pulumi.StringPtrOutput `pulumi:"serviceName"`
	// The user ID
	UserId pulumi.StringOutput `pulumi:"userId"`
}

// NewCloudProjectUserS3Policy registers a new resource with the given unique name, arguments, and options.
func NewCloudProjectUserS3Policy(ctx *pulumi.Context,
	name string, args *CloudProjectUserS3PolicyArgs, opts ...pulumi.ResourceOption) (*CloudProjectUserS3Policy, error) {
	if args == nil {
		return nil, errors.New("missing one or more required arguments")
	}

	if args.Policy == nil {
		return nil, errors.New("invalid value for required argument 'Policy'")
	}
	if args.UserId == nil {
		return nil, errors.New("invalid value for required argument 'UserId'")
	}
	opts = internal.PkgResourceDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var resource CloudProjectUserS3Policy
	err = ctx.RegisterPackageResource("ovh:index/cloudProjectUserS3Policy:CloudProjectUserS3Policy", name, args, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// GetCloudProjectUserS3Policy gets an existing CloudProjectUserS3Policy resource's state with the given name, ID, and optional
// state properties that are used to uniquely qualify the lookup (nil if not required).
func GetCloudProjectUserS3Policy(ctx *pulumi.Context,
	name string, id pulumi.IDInput, state *CloudProjectUserS3PolicyState, opts ...pulumi.ResourceOption) (*CloudProjectUserS3Policy, error) {
	var resource CloudProjectUserS3Policy
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	err = ctx.ReadPackageResource("ovh:index/cloudProjectUserS3Policy:CloudProjectUserS3Policy", name, id, state, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// Input properties used for looking up and filtering CloudProjectUserS3Policy resources.
type cloudProjectUserS3PolicyState struct {
	// The policy document. This is a JSON formatted string.
	Policy *string `pulumi:"policy"`
	// Service name of the resource representing the ID of the cloud project.
	ServiceName *string `pulumi:"serviceName"`
	// The user ID
	UserId *string `pulumi:"userId"`
}

type CloudProjectUserS3PolicyState struct {
	// The policy document. This is a JSON formatted string.
	Policy pulumi.StringPtrInput
	// Service name of the resource representing the ID of the cloud project.
	ServiceName pulumi.StringPtrInput
	// The user ID
	UserId pulumi.StringPtrInput
}

func (CloudProjectUserS3PolicyState) ElementType() reflect.Type {
	return reflect.TypeOf((*cloudProjectUserS3PolicyState)(nil)).Elem()
}

type cloudProjectUserS3PolicyArgs struct {
	// The policy document. This is a JSON formatted string.
	Policy string `pulumi:"policy"`
	// Service name of the resource representing the ID of the cloud project.
	ServiceName *string `pulumi:"serviceName"`
	// The user ID
	UserId string `pulumi:"userId"`
}

// The set of arguments for constructing a CloudProjectUserS3Policy resource.
type CloudProjectUserS3PolicyArgs struct {
	// The policy document. This is a JSON formatted string.
	Policy pulumi.StringInput
	// Service name of the resource representing the ID of the cloud project.
	ServiceName pulumi.StringPtrInput
	// The user ID
	UserId pulumi.StringInput
}

func (CloudProjectUserS3PolicyArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*cloudProjectUserS3PolicyArgs)(nil)).Elem()
}

type CloudProjectUserS3PolicyInput interface {
	pulumi.Input

	ToCloudProjectUserS3PolicyOutput() CloudProjectUserS3PolicyOutput
	ToCloudProjectUserS3PolicyOutputWithContext(ctx context.Context) CloudProjectUserS3PolicyOutput
}

func (*CloudProjectUserS3Policy) ElementType() reflect.Type {
	return reflect.TypeOf((**CloudProjectUserS3Policy)(nil)).Elem()
}

func (i *CloudProjectUserS3Policy) ToCloudProjectUserS3PolicyOutput() CloudProjectUserS3PolicyOutput {
	return i.ToCloudProjectUserS3PolicyOutputWithContext(context.Background())
}

func (i *CloudProjectUserS3Policy) ToCloudProjectUserS3PolicyOutputWithContext(ctx context.Context) CloudProjectUserS3PolicyOutput {
	return pulumi.ToOutputWithContext(ctx, i).(CloudProjectUserS3PolicyOutput)
}

type CloudProjectUserS3PolicyOutput struct{ *pulumi.OutputState }

func (CloudProjectUserS3PolicyOutput) ElementType() reflect.Type {
	return reflect.TypeOf((**CloudProjectUserS3Policy)(nil)).Elem()
}

func (o CloudProjectUserS3PolicyOutput) ToCloudProjectUserS3PolicyOutput() CloudProjectUserS3PolicyOutput {
	return o
}

func (o CloudProjectUserS3PolicyOutput) ToCloudProjectUserS3PolicyOutputWithContext(ctx context.Context) CloudProjectUserS3PolicyOutput {
	return o
}

// The policy document. This is a JSON formatted string.
func (o CloudProjectUserS3PolicyOutput) Policy() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectUserS3Policy) pulumi.StringOutput { return v.Policy }).(pulumi.StringOutput)
}

// Service name of the resource representing the ID of the cloud project.
func (o CloudProjectUserS3PolicyOutput) ServiceName() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *CloudProjectUserS3Policy) pulumi.StringPtrOutput { return v.ServiceName }).(pulumi.StringPtrOutput)
}

// The user ID
func (o CloudProjectUserS3PolicyOutput) UserId() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectUserS3Policy) pulumi.StringOutput { return v.UserId }).(pulumi.StringOutput)
}

func init() {
	pulumi.RegisterInputType(reflect.TypeOf((*CloudProjectUserS3PolicyInput)(nil)).Elem(), &CloudProjectUserS3Policy{})
	pulumi.RegisterOutputType(CloudProjectUserS3PolicyOutput{})
}

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

type CloudProjectRegionStoragePresign struct {
	pulumi.CustomResourceState

	// How long (in seconds) the URL will be valid.
	Expire pulumi.Float64Output `pulumi:"expire"`
	Method pulumi.StringOutput  `pulumi:"method"`
	// The S3 storage container's name.
	Name pulumi.StringOutput `pulumi:"name"`
	// Name of the object to download or upload.
	Object pulumi.StringOutput `pulumi:"object"`
	// Region name.
	RegionName pulumi.StringOutput `pulumi:"regionName"`
	// Service name of the resource representing the ID of the cloud project.
	ServiceName pulumi.StringPtrOutput `pulumi:"serviceName"`
	// Presigned URL.
	Url pulumi.StringOutput `pulumi:"url"`
}

// NewCloudProjectRegionStoragePresign registers a new resource with the given unique name, arguments, and options.
func NewCloudProjectRegionStoragePresign(ctx *pulumi.Context,
	name string, args *CloudProjectRegionStoragePresignArgs, opts ...pulumi.ResourceOption) (*CloudProjectRegionStoragePresign, error) {
	if args == nil {
		return nil, errors.New("missing one or more required arguments")
	}

	if args.Expire == nil {
		return nil, errors.New("invalid value for required argument 'Expire'")
	}
	if args.Method == nil {
		return nil, errors.New("invalid value for required argument 'Method'")
	}
	if args.Object == nil {
		return nil, errors.New("invalid value for required argument 'Object'")
	}
	if args.RegionName == nil {
		return nil, errors.New("invalid value for required argument 'RegionName'")
	}
	opts = internal.PkgResourceDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var resource CloudProjectRegionStoragePresign
	err = ctx.RegisterPackageResource("ovh:index/cloudProjectRegionStoragePresign:CloudProjectRegionStoragePresign", name, args, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// GetCloudProjectRegionStoragePresign gets an existing CloudProjectRegionStoragePresign resource's state with the given name, ID, and optional
// state properties that are used to uniquely qualify the lookup (nil if not required).
func GetCloudProjectRegionStoragePresign(ctx *pulumi.Context,
	name string, id pulumi.IDInput, state *CloudProjectRegionStoragePresignState, opts ...pulumi.ResourceOption) (*CloudProjectRegionStoragePresign, error) {
	var resource CloudProjectRegionStoragePresign
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	err = ctx.ReadPackageResource("ovh:index/cloudProjectRegionStoragePresign:CloudProjectRegionStoragePresign", name, id, state, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// Input properties used for looking up and filtering CloudProjectRegionStoragePresign resources.
type cloudProjectRegionStoragePresignState struct {
	// How long (in seconds) the URL will be valid.
	Expire *float64 `pulumi:"expire"`
	Method *string  `pulumi:"method"`
	// The S3 storage container's name.
	Name *string `pulumi:"name"`
	// Name of the object to download or upload.
	Object *string `pulumi:"object"`
	// Region name.
	RegionName *string `pulumi:"regionName"`
	// Service name of the resource representing the ID of the cloud project.
	ServiceName *string `pulumi:"serviceName"`
	// Presigned URL.
	Url *string `pulumi:"url"`
}

type CloudProjectRegionStoragePresignState struct {
	// How long (in seconds) the URL will be valid.
	Expire pulumi.Float64PtrInput
	Method pulumi.StringPtrInput
	// The S3 storage container's name.
	Name pulumi.StringPtrInput
	// Name of the object to download or upload.
	Object pulumi.StringPtrInput
	// Region name.
	RegionName pulumi.StringPtrInput
	// Service name of the resource representing the ID of the cloud project.
	ServiceName pulumi.StringPtrInput
	// Presigned URL.
	Url pulumi.StringPtrInput
}

func (CloudProjectRegionStoragePresignState) ElementType() reflect.Type {
	return reflect.TypeOf((*cloudProjectRegionStoragePresignState)(nil)).Elem()
}

type cloudProjectRegionStoragePresignArgs struct {
	// How long (in seconds) the URL will be valid.
	Expire float64 `pulumi:"expire"`
	Method string  `pulumi:"method"`
	// The S3 storage container's name.
	Name *string `pulumi:"name"`
	// Name of the object to download or upload.
	Object string `pulumi:"object"`
	// Region name.
	RegionName string `pulumi:"regionName"`
	// Service name of the resource representing the ID of the cloud project.
	ServiceName *string `pulumi:"serviceName"`
}

// The set of arguments for constructing a CloudProjectRegionStoragePresign resource.
type CloudProjectRegionStoragePresignArgs struct {
	// How long (in seconds) the URL will be valid.
	Expire pulumi.Float64Input
	Method pulumi.StringInput
	// The S3 storage container's name.
	Name pulumi.StringPtrInput
	// Name of the object to download or upload.
	Object pulumi.StringInput
	// Region name.
	RegionName pulumi.StringInput
	// Service name of the resource representing the ID of the cloud project.
	ServiceName pulumi.StringPtrInput
}

func (CloudProjectRegionStoragePresignArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*cloudProjectRegionStoragePresignArgs)(nil)).Elem()
}

type CloudProjectRegionStoragePresignInput interface {
	pulumi.Input

	ToCloudProjectRegionStoragePresignOutput() CloudProjectRegionStoragePresignOutput
	ToCloudProjectRegionStoragePresignOutputWithContext(ctx context.Context) CloudProjectRegionStoragePresignOutput
}

func (*CloudProjectRegionStoragePresign) ElementType() reflect.Type {
	return reflect.TypeOf((**CloudProjectRegionStoragePresign)(nil)).Elem()
}

func (i *CloudProjectRegionStoragePresign) ToCloudProjectRegionStoragePresignOutput() CloudProjectRegionStoragePresignOutput {
	return i.ToCloudProjectRegionStoragePresignOutputWithContext(context.Background())
}

func (i *CloudProjectRegionStoragePresign) ToCloudProjectRegionStoragePresignOutputWithContext(ctx context.Context) CloudProjectRegionStoragePresignOutput {
	return pulumi.ToOutputWithContext(ctx, i).(CloudProjectRegionStoragePresignOutput)
}

type CloudProjectRegionStoragePresignOutput struct{ *pulumi.OutputState }

func (CloudProjectRegionStoragePresignOutput) ElementType() reflect.Type {
	return reflect.TypeOf((**CloudProjectRegionStoragePresign)(nil)).Elem()
}

func (o CloudProjectRegionStoragePresignOutput) ToCloudProjectRegionStoragePresignOutput() CloudProjectRegionStoragePresignOutput {
	return o
}

func (o CloudProjectRegionStoragePresignOutput) ToCloudProjectRegionStoragePresignOutputWithContext(ctx context.Context) CloudProjectRegionStoragePresignOutput {
	return o
}

// How long (in seconds) the URL will be valid.
func (o CloudProjectRegionStoragePresignOutput) Expire() pulumi.Float64Output {
	return o.ApplyT(func(v *CloudProjectRegionStoragePresign) pulumi.Float64Output { return v.Expire }).(pulumi.Float64Output)
}

func (o CloudProjectRegionStoragePresignOutput) Method() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectRegionStoragePresign) pulumi.StringOutput { return v.Method }).(pulumi.StringOutput)
}

// The S3 storage container's name.
func (o CloudProjectRegionStoragePresignOutput) Name() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectRegionStoragePresign) pulumi.StringOutput { return v.Name }).(pulumi.StringOutput)
}

// Name of the object to download or upload.
func (o CloudProjectRegionStoragePresignOutput) Object() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectRegionStoragePresign) pulumi.StringOutput { return v.Object }).(pulumi.StringOutput)
}

// Region name.
func (o CloudProjectRegionStoragePresignOutput) RegionName() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectRegionStoragePresign) pulumi.StringOutput { return v.RegionName }).(pulumi.StringOutput)
}

// Service name of the resource representing the ID of the cloud project.
func (o CloudProjectRegionStoragePresignOutput) ServiceName() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *CloudProjectRegionStoragePresign) pulumi.StringPtrOutput { return v.ServiceName }).(pulumi.StringPtrOutput)
}

// Presigned URL.
func (o CloudProjectRegionStoragePresignOutput) Url() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectRegionStoragePresign) pulumi.StringOutput { return v.Url }).(pulumi.StringOutput)
}

func init() {
	pulumi.RegisterInputType(reflect.TypeOf((*CloudProjectRegionStoragePresignInput)(nil)).Elem(), &CloudProjectRegionStoragePresign{})
	pulumi.RegisterOutputType(CloudProjectRegionStoragePresignOutput{})
}

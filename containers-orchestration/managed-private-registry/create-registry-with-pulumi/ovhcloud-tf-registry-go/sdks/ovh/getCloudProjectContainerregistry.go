// Code generated by pulumi-language-go DO NOT EDIT.
// *** WARNING: Do not edit by hand unless you're certain you know what you are doing! ***

package ovh

import (
	"context"
	"reflect"

	"github.com/pulumi/pulumi-terraform-provider/sdks/go/ovh/internal"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func LookupCloudProjectContainerregistry(ctx *pulumi.Context, args *LookupCloudProjectContainerregistryArgs, opts ...pulumi.InvokeOption) (*LookupCloudProjectContainerregistryResult, error) {
	opts = internal.PkgInvokeDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var rv LookupCloudProjectContainerregistryResult
	err = ctx.InvokePackage("ovh:index/getCloudProjectContainerregistry:getCloudProjectContainerregistry", args, &rv, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &rv, nil
}

// A collection of arguments for invoking getCloudProjectContainerregistry.
type LookupCloudProjectContainerregistryArgs struct {
	Id          *string `pulumi:"id"`
	RegistryId  string  `pulumi:"registryId"`
	ServiceName *string `pulumi:"serviceName"`
}

// A collection of values returned by getCloudProjectContainerregistry.
type LookupCloudProjectContainerregistryResult struct {
	CreatedAt   string  `pulumi:"createdAt"`
	Id          string  `pulumi:"id"`
	Name        string  `pulumi:"name"`
	ProjectId   string  `pulumi:"projectId"`
	Region      string  `pulumi:"region"`
	RegistryId  string  `pulumi:"registryId"`
	ServiceName *string `pulumi:"serviceName"`
	Size        float64 `pulumi:"size"`
	Status      string  `pulumi:"status"`
	UpdatedAt   string  `pulumi:"updatedAt"`
	Url         string  `pulumi:"url"`
	Version     string  `pulumi:"version"`
}

func LookupCloudProjectContainerregistryOutput(ctx *pulumi.Context, args LookupCloudProjectContainerregistryOutputArgs, opts ...pulumi.InvokeOption) LookupCloudProjectContainerregistryResultOutput {
	return pulumi.ToOutputWithContext(context.Background(), args).
		ApplyT(func(v interface{}) (LookupCloudProjectContainerregistryResult, error) {
			args := v.(LookupCloudProjectContainerregistryArgs)
			r, err := LookupCloudProjectContainerregistry(ctx, &args, opts...)
			var s LookupCloudProjectContainerregistryResult
			if r != nil {
				s = *r
			}
			return s, err
		}).(LookupCloudProjectContainerregistryResultOutput)
}

// A collection of arguments for invoking getCloudProjectContainerregistry.
type LookupCloudProjectContainerregistryOutputArgs struct {
	Id          pulumi.StringPtrInput `pulumi:"id"`
	RegistryId  pulumi.StringInput    `pulumi:"registryId"`
	ServiceName pulumi.StringPtrInput `pulumi:"serviceName"`
}

func (LookupCloudProjectContainerregistryOutputArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*LookupCloudProjectContainerregistryArgs)(nil)).Elem()
}

// A collection of values returned by getCloudProjectContainerregistry.
type LookupCloudProjectContainerregistryResultOutput struct{ *pulumi.OutputState }

func (LookupCloudProjectContainerregistryResultOutput) ElementType() reflect.Type {
	return reflect.TypeOf((*LookupCloudProjectContainerregistryResult)(nil)).Elem()
}

func (o LookupCloudProjectContainerregistryResultOutput) ToLookupCloudProjectContainerregistryResultOutput() LookupCloudProjectContainerregistryResultOutput {
	return o
}

func (o LookupCloudProjectContainerregistryResultOutput) ToLookupCloudProjectContainerregistryResultOutputWithContext(ctx context.Context) LookupCloudProjectContainerregistryResultOutput {
	return o
}

func (o LookupCloudProjectContainerregistryResultOutput) CreatedAt() pulumi.StringOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) string { return v.CreatedAt }).(pulumi.StringOutput)
}

func (o LookupCloudProjectContainerregistryResultOutput) Id() pulumi.StringOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) string { return v.Id }).(pulumi.StringOutput)
}

func (o LookupCloudProjectContainerregistryResultOutput) Name() pulumi.StringOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) string { return v.Name }).(pulumi.StringOutput)
}

func (o LookupCloudProjectContainerregistryResultOutput) ProjectId() pulumi.StringOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) string { return v.ProjectId }).(pulumi.StringOutput)
}

func (o LookupCloudProjectContainerregistryResultOutput) Region() pulumi.StringOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) string { return v.Region }).(pulumi.StringOutput)
}

func (o LookupCloudProjectContainerregistryResultOutput) RegistryId() pulumi.StringOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) string { return v.RegistryId }).(pulumi.StringOutput)
}

func (o LookupCloudProjectContainerregistryResultOutput) ServiceName() pulumi.StringPtrOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) *string { return v.ServiceName }).(pulumi.StringPtrOutput)
}

func (o LookupCloudProjectContainerregistryResultOutput) Size() pulumi.Float64Output {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) float64 { return v.Size }).(pulumi.Float64Output)
}

func (o LookupCloudProjectContainerregistryResultOutput) Status() pulumi.StringOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) string { return v.Status }).(pulumi.StringOutput)
}

func (o LookupCloudProjectContainerregistryResultOutput) UpdatedAt() pulumi.StringOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) string { return v.UpdatedAt }).(pulumi.StringOutput)
}

func (o LookupCloudProjectContainerregistryResultOutput) Url() pulumi.StringOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) string { return v.Url }).(pulumi.StringOutput)
}

func (o LookupCloudProjectContainerregistryResultOutput) Version() pulumi.StringOutput {
	return o.ApplyT(func(v LookupCloudProjectContainerregistryResult) string { return v.Version }).(pulumi.StringOutput)
}

func init() {
	pulumi.RegisterOutputType(LookupCloudProjectContainerregistryResultOutput{})
}

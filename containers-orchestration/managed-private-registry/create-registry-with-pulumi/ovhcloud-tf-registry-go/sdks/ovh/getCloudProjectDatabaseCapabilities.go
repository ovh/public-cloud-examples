// Code generated by pulumi-language-go DO NOT EDIT.
// *** WARNING: Do not edit by hand unless you're certain you know what you are doing! ***

package ovh

import (
	"context"
	"reflect"

	"github.com/pulumi/pulumi-terraform-provider/sdks/go/ovh/internal"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func GetCloudProjectDatabaseCapabilities(ctx *pulumi.Context, args *GetCloudProjectDatabaseCapabilitiesArgs, opts ...pulumi.InvokeOption) (*GetCloudProjectDatabaseCapabilitiesResult, error) {
	opts = internal.PkgInvokeDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var rv GetCloudProjectDatabaseCapabilitiesResult
	err = ctx.InvokePackage("ovh:index/getCloudProjectDatabaseCapabilities:getCloudProjectDatabaseCapabilities", args, &rv, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &rv, nil
}

// A collection of arguments for invoking getCloudProjectDatabaseCapabilities.
type GetCloudProjectDatabaseCapabilitiesArgs struct {
	Id          *string `pulumi:"id"`
	ServiceName *string `pulumi:"serviceName"`
}

// A collection of values returned by getCloudProjectDatabaseCapabilities.
type GetCloudProjectDatabaseCapabilitiesResult struct {
	Engines     []GetCloudProjectDatabaseCapabilitiesEngine `pulumi:"engines"`
	Flavors     []GetCloudProjectDatabaseCapabilitiesFlavor `pulumi:"flavors"`
	Id          string                                      `pulumi:"id"`
	Options     []GetCloudProjectDatabaseCapabilitiesOption `pulumi:"options"`
	Plans       []GetCloudProjectDatabaseCapabilitiesPlan   `pulumi:"plans"`
	ServiceName *string                                     `pulumi:"serviceName"`
}

func GetCloudProjectDatabaseCapabilitiesOutput(ctx *pulumi.Context, args GetCloudProjectDatabaseCapabilitiesOutputArgs, opts ...pulumi.InvokeOption) GetCloudProjectDatabaseCapabilitiesResultOutput {
	return pulumi.ToOutputWithContext(context.Background(), args).
		ApplyT(func(v interface{}) (GetCloudProjectDatabaseCapabilitiesResult, error) {
			args := v.(GetCloudProjectDatabaseCapabilitiesArgs)
			r, err := GetCloudProjectDatabaseCapabilities(ctx, &args, opts...)
			var s GetCloudProjectDatabaseCapabilitiesResult
			if r != nil {
				s = *r
			}
			return s, err
		}).(GetCloudProjectDatabaseCapabilitiesResultOutput)
}

// A collection of arguments for invoking getCloudProjectDatabaseCapabilities.
type GetCloudProjectDatabaseCapabilitiesOutputArgs struct {
	Id          pulumi.StringPtrInput `pulumi:"id"`
	ServiceName pulumi.StringPtrInput `pulumi:"serviceName"`
}

func (GetCloudProjectDatabaseCapabilitiesOutputArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*GetCloudProjectDatabaseCapabilitiesArgs)(nil)).Elem()
}

// A collection of values returned by getCloudProjectDatabaseCapabilities.
type GetCloudProjectDatabaseCapabilitiesResultOutput struct{ *pulumi.OutputState }

func (GetCloudProjectDatabaseCapabilitiesResultOutput) ElementType() reflect.Type {
	return reflect.TypeOf((*GetCloudProjectDatabaseCapabilitiesResult)(nil)).Elem()
}

func (o GetCloudProjectDatabaseCapabilitiesResultOutput) ToGetCloudProjectDatabaseCapabilitiesResultOutput() GetCloudProjectDatabaseCapabilitiesResultOutput {
	return o
}

func (o GetCloudProjectDatabaseCapabilitiesResultOutput) ToGetCloudProjectDatabaseCapabilitiesResultOutputWithContext(ctx context.Context) GetCloudProjectDatabaseCapabilitiesResultOutput {
	return o
}

func (o GetCloudProjectDatabaseCapabilitiesResultOutput) Engines() GetCloudProjectDatabaseCapabilitiesEngineArrayOutput {
	return o.ApplyT(func(v GetCloudProjectDatabaseCapabilitiesResult) []GetCloudProjectDatabaseCapabilitiesEngine {
		return v.Engines
	}).(GetCloudProjectDatabaseCapabilitiesEngineArrayOutput)
}

func (o GetCloudProjectDatabaseCapabilitiesResultOutput) Flavors() GetCloudProjectDatabaseCapabilitiesFlavorArrayOutput {
	return o.ApplyT(func(v GetCloudProjectDatabaseCapabilitiesResult) []GetCloudProjectDatabaseCapabilitiesFlavor {
		return v.Flavors
	}).(GetCloudProjectDatabaseCapabilitiesFlavorArrayOutput)
}

func (o GetCloudProjectDatabaseCapabilitiesResultOutput) Id() pulumi.StringOutput {
	return o.ApplyT(func(v GetCloudProjectDatabaseCapabilitiesResult) string { return v.Id }).(pulumi.StringOutput)
}

func (o GetCloudProjectDatabaseCapabilitiesResultOutput) Options() GetCloudProjectDatabaseCapabilitiesOptionArrayOutput {
	return o.ApplyT(func(v GetCloudProjectDatabaseCapabilitiesResult) []GetCloudProjectDatabaseCapabilitiesOption {
		return v.Options
	}).(GetCloudProjectDatabaseCapabilitiesOptionArrayOutput)
}

func (o GetCloudProjectDatabaseCapabilitiesResultOutput) Plans() GetCloudProjectDatabaseCapabilitiesPlanArrayOutput {
	return o.ApplyT(func(v GetCloudProjectDatabaseCapabilitiesResult) []GetCloudProjectDatabaseCapabilitiesPlan {
		return v.Plans
	}).(GetCloudProjectDatabaseCapabilitiesPlanArrayOutput)
}

func (o GetCloudProjectDatabaseCapabilitiesResultOutput) ServiceName() pulumi.StringPtrOutput {
	return o.ApplyT(func(v GetCloudProjectDatabaseCapabilitiesResult) *string { return v.ServiceName }).(pulumi.StringPtrOutput)
}

func init() {
	pulumi.RegisterOutputType(GetCloudProjectDatabaseCapabilitiesResultOutput{})
}

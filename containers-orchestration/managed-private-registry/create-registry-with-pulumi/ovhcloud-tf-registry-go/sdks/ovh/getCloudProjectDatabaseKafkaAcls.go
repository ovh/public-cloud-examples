// Code generated by pulumi-language-go DO NOT EDIT.
// *** WARNING: Do not edit by hand unless you're certain you know what you are doing! ***

package ovh

import (
	"context"
	"reflect"

	"github.com/pulumi/pulumi-terraform-provider/sdks/go/ovh/internal"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func GetCloudProjectDatabaseKafkaAcls(ctx *pulumi.Context, args *GetCloudProjectDatabaseKafkaAclsArgs, opts ...pulumi.InvokeOption) (*GetCloudProjectDatabaseKafkaAclsResult, error) {
	opts = internal.PkgInvokeDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var rv GetCloudProjectDatabaseKafkaAclsResult
	err = ctx.InvokePackage("ovh:index/getCloudProjectDatabaseKafkaAcls:getCloudProjectDatabaseKafkaAcls", args, &rv, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &rv, nil
}

// A collection of arguments for invoking getCloudProjectDatabaseKafkaAcls.
type GetCloudProjectDatabaseKafkaAclsArgs struct {
	ClusterId   string  `pulumi:"clusterId"`
	Id          *string `pulumi:"id"`
	ServiceName *string `pulumi:"serviceName"`
}

// A collection of values returned by getCloudProjectDatabaseKafkaAcls.
type GetCloudProjectDatabaseKafkaAclsResult struct {
	AclIds      []string `pulumi:"aclIds"`
	ClusterId   string   `pulumi:"clusterId"`
	Id          string   `pulumi:"id"`
	ServiceName *string  `pulumi:"serviceName"`
}

func GetCloudProjectDatabaseKafkaAclsOutput(ctx *pulumi.Context, args GetCloudProjectDatabaseKafkaAclsOutputArgs, opts ...pulumi.InvokeOption) GetCloudProjectDatabaseKafkaAclsResultOutput {
	return pulumi.ToOutputWithContext(context.Background(), args).
		ApplyT(func(v interface{}) (GetCloudProjectDatabaseKafkaAclsResult, error) {
			args := v.(GetCloudProjectDatabaseKafkaAclsArgs)
			r, err := GetCloudProjectDatabaseKafkaAcls(ctx, &args, opts...)
			var s GetCloudProjectDatabaseKafkaAclsResult
			if r != nil {
				s = *r
			}
			return s, err
		}).(GetCloudProjectDatabaseKafkaAclsResultOutput)
}

// A collection of arguments for invoking getCloudProjectDatabaseKafkaAcls.
type GetCloudProjectDatabaseKafkaAclsOutputArgs struct {
	ClusterId   pulumi.StringInput    `pulumi:"clusterId"`
	Id          pulumi.StringPtrInput `pulumi:"id"`
	ServiceName pulumi.StringPtrInput `pulumi:"serviceName"`
}

func (GetCloudProjectDatabaseKafkaAclsOutputArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*GetCloudProjectDatabaseKafkaAclsArgs)(nil)).Elem()
}

// A collection of values returned by getCloudProjectDatabaseKafkaAcls.
type GetCloudProjectDatabaseKafkaAclsResultOutput struct{ *pulumi.OutputState }

func (GetCloudProjectDatabaseKafkaAclsResultOutput) ElementType() reflect.Type {
	return reflect.TypeOf((*GetCloudProjectDatabaseKafkaAclsResult)(nil)).Elem()
}

func (o GetCloudProjectDatabaseKafkaAclsResultOutput) ToGetCloudProjectDatabaseKafkaAclsResultOutput() GetCloudProjectDatabaseKafkaAclsResultOutput {
	return o
}

func (o GetCloudProjectDatabaseKafkaAclsResultOutput) ToGetCloudProjectDatabaseKafkaAclsResultOutputWithContext(ctx context.Context) GetCloudProjectDatabaseKafkaAclsResultOutput {
	return o
}

func (o GetCloudProjectDatabaseKafkaAclsResultOutput) AclIds() pulumi.StringArrayOutput {
	return o.ApplyT(func(v GetCloudProjectDatabaseKafkaAclsResult) []string { return v.AclIds }).(pulumi.StringArrayOutput)
}

func (o GetCloudProjectDatabaseKafkaAclsResultOutput) ClusterId() pulumi.StringOutput {
	return o.ApplyT(func(v GetCloudProjectDatabaseKafkaAclsResult) string { return v.ClusterId }).(pulumi.StringOutput)
}

func (o GetCloudProjectDatabaseKafkaAclsResultOutput) Id() pulumi.StringOutput {
	return o.ApplyT(func(v GetCloudProjectDatabaseKafkaAclsResult) string { return v.Id }).(pulumi.StringOutput)
}

func (o GetCloudProjectDatabaseKafkaAclsResultOutput) ServiceName() pulumi.StringPtrOutput {
	return o.ApplyT(func(v GetCloudProjectDatabaseKafkaAclsResult) *string { return v.ServiceName }).(pulumi.StringPtrOutput)
}

func init() {
	pulumi.RegisterOutputType(GetCloudProjectDatabaseKafkaAclsResultOutput{})
}

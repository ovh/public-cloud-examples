// Code generated by pulumi-language-go DO NOT EDIT.
// *** WARNING: Do not edit by hand unless you're certain you know what you are doing! ***

package ovh

import (
	"context"
	"reflect"

	"github.com/pulumi/pulumi-terraform-provider/sdks/go/ovh/internal"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func GetMeIdentityUsers(ctx *pulumi.Context, args *GetMeIdentityUsersArgs, opts ...pulumi.InvokeOption) (*GetMeIdentityUsersResult, error) {
	opts = internal.PkgInvokeDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var rv GetMeIdentityUsersResult
	err = ctx.InvokePackage("ovh:index/getMeIdentityUsers:getMeIdentityUsers", args, &rv, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &rv, nil
}

// A collection of arguments for invoking getMeIdentityUsers.
type GetMeIdentityUsersArgs struct {
	Id *string `pulumi:"id"`
}

// A collection of values returned by getMeIdentityUsers.
type GetMeIdentityUsersResult struct {
	Id    string   `pulumi:"id"`
	Users []string `pulumi:"users"`
}

func GetMeIdentityUsersOutput(ctx *pulumi.Context, args GetMeIdentityUsersOutputArgs, opts ...pulumi.InvokeOption) GetMeIdentityUsersResultOutput {
	return pulumi.ToOutputWithContext(context.Background(), args).
		ApplyT(func(v interface{}) (GetMeIdentityUsersResult, error) {
			args := v.(GetMeIdentityUsersArgs)
			r, err := GetMeIdentityUsers(ctx, &args, opts...)
			var s GetMeIdentityUsersResult
			if r != nil {
				s = *r
			}
			return s, err
		}).(GetMeIdentityUsersResultOutput)
}

// A collection of arguments for invoking getMeIdentityUsers.
type GetMeIdentityUsersOutputArgs struct {
	Id pulumi.StringPtrInput `pulumi:"id"`
}

func (GetMeIdentityUsersOutputArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*GetMeIdentityUsersArgs)(nil)).Elem()
}

// A collection of values returned by getMeIdentityUsers.
type GetMeIdentityUsersResultOutput struct{ *pulumi.OutputState }

func (GetMeIdentityUsersResultOutput) ElementType() reflect.Type {
	return reflect.TypeOf((*GetMeIdentityUsersResult)(nil)).Elem()
}

func (o GetMeIdentityUsersResultOutput) ToGetMeIdentityUsersResultOutput() GetMeIdentityUsersResultOutput {
	return o
}

func (o GetMeIdentityUsersResultOutput) ToGetMeIdentityUsersResultOutputWithContext(ctx context.Context) GetMeIdentityUsersResultOutput {
	return o
}

func (o GetMeIdentityUsersResultOutput) Id() pulumi.StringOutput {
	return o.ApplyT(func(v GetMeIdentityUsersResult) string { return v.Id }).(pulumi.StringOutput)
}

func (o GetMeIdentityUsersResultOutput) Users() pulumi.StringArrayOutput {
	return o.ApplyT(func(v GetMeIdentityUsersResult) []string { return v.Users }).(pulumi.StringArrayOutput)
}

func init() {
	pulumi.RegisterOutputType(GetMeIdentityUsersResultOutput{})
}

// Code generated by pulumi-language-go DO NOT EDIT.
// *** WARNING: Do not edit by hand unless you're certain you know what you are doing! ***

package ovh

import (
	"context"
	"reflect"

	"github.com/pulumi/pulumi-terraform-provider/sdks/go/ovh/internal"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func GetOrderCart(ctx *pulumi.Context, args *GetOrderCartArgs, opts ...pulumi.InvokeOption) (*GetOrderCartResult, error) {
	opts = internal.PkgInvokeDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var rv GetOrderCartResult
	err = ctx.InvokePackage("ovh:index/getOrderCart:getOrderCart", args, &rv, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &rv, nil
}

// A collection of arguments for invoking getOrderCart.
type GetOrderCartArgs struct {
	Assign        *bool   `pulumi:"assign"`
	Description   *string `pulumi:"description"`
	Expire        *string `pulumi:"expire"`
	Id            *string `pulumi:"id"`
	OvhSubsidiary string  `pulumi:"ovhSubsidiary"`
}

// A collection of values returned by getOrderCart.
type GetOrderCartResult struct {
	Assign        *bool     `pulumi:"assign"`
	CartId        string    `pulumi:"cartId"`
	Description   *string   `pulumi:"description"`
	Expire        string    `pulumi:"expire"`
	Id            string    `pulumi:"id"`
	Items         []float64 `pulumi:"items"`
	OvhSubsidiary string    `pulumi:"ovhSubsidiary"`
	ReadOnly      bool      `pulumi:"readOnly"`
}

func GetOrderCartOutput(ctx *pulumi.Context, args GetOrderCartOutputArgs, opts ...pulumi.InvokeOption) GetOrderCartResultOutput {
	return pulumi.ToOutputWithContext(context.Background(), args).
		ApplyT(func(v interface{}) (GetOrderCartResult, error) {
			args := v.(GetOrderCartArgs)
			r, err := GetOrderCart(ctx, &args, opts...)
			var s GetOrderCartResult
			if r != nil {
				s = *r
			}
			return s, err
		}).(GetOrderCartResultOutput)
}

// A collection of arguments for invoking getOrderCart.
type GetOrderCartOutputArgs struct {
	Assign        pulumi.BoolPtrInput   `pulumi:"assign"`
	Description   pulumi.StringPtrInput `pulumi:"description"`
	Expire        pulumi.StringPtrInput `pulumi:"expire"`
	Id            pulumi.StringPtrInput `pulumi:"id"`
	OvhSubsidiary pulumi.StringInput    `pulumi:"ovhSubsidiary"`
}

func (GetOrderCartOutputArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*GetOrderCartArgs)(nil)).Elem()
}

// A collection of values returned by getOrderCart.
type GetOrderCartResultOutput struct{ *pulumi.OutputState }

func (GetOrderCartResultOutput) ElementType() reflect.Type {
	return reflect.TypeOf((*GetOrderCartResult)(nil)).Elem()
}

func (o GetOrderCartResultOutput) ToGetOrderCartResultOutput() GetOrderCartResultOutput {
	return o
}

func (o GetOrderCartResultOutput) ToGetOrderCartResultOutputWithContext(ctx context.Context) GetOrderCartResultOutput {
	return o
}

func (o GetOrderCartResultOutput) Assign() pulumi.BoolPtrOutput {
	return o.ApplyT(func(v GetOrderCartResult) *bool { return v.Assign }).(pulumi.BoolPtrOutput)
}

func (o GetOrderCartResultOutput) CartId() pulumi.StringOutput {
	return o.ApplyT(func(v GetOrderCartResult) string { return v.CartId }).(pulumi.StringOutput)
}

func (o GetOrderCartResultOutput) Description() pulumi.StringPtrOutput {
	return o.ApplyT(func(v GetOrderCartResult) *string { return v.Description }).(pulumi.StringPtrOutput)
}

func (o GetOrderCartResultOutput) Expire() pulumi.StringOutput {
	return o.ApplyT(func(v GetOrderCartResult) string { return v.Expire }).(pulumi.StringOutput)
}

func (o GetOrderCartResultOutput) Id() pulumi.StringOutput {
	return o.ApplyT(func(v GetOrderCartResult) string { return v.Id }).(pulumi.StringOutput)
}

func (o GetOrderCartResultOutput) Items() pulumi.Float64ArrayOutput {
	return o.ApplyT(func(v GetOrderCartResult) []float64 { return v.Items }).(pulumi.Float64ArrayOutput)
}

func (o GetOrderCartResultOutput) OvhSubsidiary() pulumi.StringOutput {
	return o.ApplyT(func(v GetOrderCartResult) string { return v.OvhSubsidiary }).(pulumi.StringOutput)
}

func (o GetOrderCartResultOutput) ReadOnly() pulumi.BoolOutput {
	return o.ApplyT(func(v GetOrderCartResult) bool { return v.ReadOnly }).(pulumi.BoolOutput)
}

func init() {
	pulumi.RegisterOutputType(GetOrderCartResultOutput{})
}

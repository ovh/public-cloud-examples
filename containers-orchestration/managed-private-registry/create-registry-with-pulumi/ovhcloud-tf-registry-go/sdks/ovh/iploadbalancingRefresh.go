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

type IploadbalancingRefresh struct {
	pulumi.CustomResourceState

	Keepers     pulumi.StringArrayOutput `pulumi:"keepers"`
	ServiceName pulumi.StringOutput      `pulumi:"serviceName"`
}

// NewIploadbalancingRefresh registers a new resource with the given unique name, arguments, and options.
func NewIploadbalancingRefresh(ctx *pulumi.Context,
	name string, args *IploadbalancingRefreshArgs, opts ...pulumi.ResourceOption) (*IploadbalancingRefresh, error) {
	if args == nil {
		return nil, errors.New("missing one or more required arguments")
	}

	if args.Keepers == nil {
		return nil, errors.New("invalid value for required argument 'Keepers'")
	}
	if args.ServiceName == nil {
		return nil, errors.New("invalid value for required argument 'ServiceName'")
	}
	opts = internal.PkgResourceDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var resource IploadbalancingRefresh
	err = ctx.RegisterPackageResource("ovh:index/iploadbalancingRefresh:IploadbalancingRefresh", name, args, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// GetIploadbalancingRefresh gets an existing IploadbalancingRefresh resource's state with the given name, ID, and optional
// state properties that are used to uniquely qualify the lookup (nil if not required).
func GetIploadbalancingRefresh(ctx *pulumi.Context,
	name string, id pulumi.IDInput, state *IploadbalancingRefreshState, opts ...pulumi.ResourceOption) (*IploadbalancingRefresh, error) {
	var resource IploadbalancingRefresh
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	err = ctx.ReadPackageResource("ovh:index/iploadbalancingRefresh:IploadbalancingRefresh", name, id, state, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// Input properties used for looking up and filtering IploadbalancingRefresh resources.
type iploadbalancingRefreshState struct {
	Keepers     []string `pulumi:"keepers"`
	ServiceName *string  `pulumi:"serviceName"`
}

type IploadbalancingRefreshState struct {
	Keepers     pulumi.StringArrayInput
	ServiceName pulumi.StringPtrInput
}

func (IploadbalancingRefreshState) ElementType() reflect.Type {
	return reflect.TypeOf((*iploadbalancingRefreshState)(nil)).Elem()
}

type iploadbalancingRefreshArgs struct {
	Keepers     []string `pulumi:"keepers"`
	ServiceName string   `pulumi:"serviceName"`
}

// The set of arguments for constructing a IploadbalancingRefresh resource.
type IploadbalancingRefreshArgs struct {
	Keepers     pulumi.StringArrayInput
	ServiceName pulumi.StringInput
}

func (IploadbalancingRefreshArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*iploadbalancingRefreshArgs)(nil)).Elem()
}

type IploadbalancingRefreshInput interface {
	pulumi.Input

	ToIploadbalancingRefreshOutput() IploadbalancingRefreshOutput
	ToIploadbalancingRefreshOutputWithContext(ctx context.Context) IploadbalancingRefreshOutput
}

func (*IploadbalancingRefresh) ElementType() reflect.Type {
	return reflect.TypeOf((**IploadbalancingRefresh)(nil)).Elem()
}

func (i *IploadbalancingRefresh) ToIploadbalancingRefreshOutput() IploadbalancingRefreshOutput {
	return i.ToIploadbalancingRefreshOutputWithContext(context.Background())
}

func (i *IploadbalancingRefresh) ToIploadbalancingRefreshOutputWithContext(ctx context.Context) IploadbalancingRefreshOutput {
	return pulumi.ToOutputWithContext(ctx, i).(IploadbalancingRefreshOutput)
}

type IploadbalancingRefreshOutput struct{ *pulumi.OutputState }

func (IploadbalancingRefreshOutput) ElementType() reflect.Type {
	return reflect.TypeOf((**IploadbalancingRefresh)(nil)).Elem()
}

func (o IploadbalancingRefreshOutput) ToIploadbalancingRefreshOutput() IploadbalancingRefreshOutput {
	return o
}

func (o IploadbalancingRefreshOutput) ToIploadbalancingRefreshOutputWithContext(ctx context.Context) IploadbalancingRefreshOutput {
	return o
}

func (o IploadbalancingRefreshOutput) Keepers() pulumi.StringArrayOutput {
	return o.ApplyT(func(v *IploadbalancingRefresh) pulumi.StringArrayOutput { return v.Keepers }).(pulumi.StringArrayOutput)
}

func (o IploadbalancingRefreshOutput) ServiceName() pulumi.StringOutput {
	return o.ApplyT(func(v *IploadbalancingRefresh) pulumi.StringOutput { return v.ServiceName }).(pulumi.StringOutput)
}

func init() {
	pulumi.RegisterInputType(reflect.TypeOf((*IploadbalancingRefreshInput)(nil)).Elem(), &IploadbalancingRefresh{})
	pulumi.RegisterOutputType(IploadbalancingRefreshOutput{})
}

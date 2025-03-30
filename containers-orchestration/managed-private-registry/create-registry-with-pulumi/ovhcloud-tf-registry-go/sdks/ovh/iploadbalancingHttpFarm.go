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

type IploadbalancingHttpFarm struct {
	pulumi.CustomResourceState

	Balance        pulumi.StringPtrOutput                `pulumi:"balance"`
	DisplayName    pulumi.StringPtrOutput                `pulumi:"displayName"`
	Port           pulumi.Float64PtrOutput               `pulumi:"port"`
	Probe          IploadbalancingHttpFarmProbePtrOutput `pulumi:"probe"`
	ServiceName    pulumi.StringOutput                   `pulumi:"serviceName"`
	Stickiness     pulumi.StringPtrOutput                `pulumi:"stickiness"`
	VrackNetworkId pulumi.Float64PtrOutput               `pulumi:"vrackNetworkId"`
	Zone           pulumi.StringOutput                   `pulumi:"zone"`
}

// NewIploadbalancingHttpFarm registers a new resource with the given unique name, arguments, and options.
func NewIploadbalancingHttpFarm(ctx *pulumi.Context,
	name string, args *IploadbalancingHttpFarmArgs, opts ...pulumi.ResourceOption) (*IploadbalancingHttpFarm, error) {
	if args == nil {
		return nil, errors.New("missing one or more required arguments")
	}

	if args.ServiceName == nil {
		return nil, errors.New("invalid value for required argument 'ServiceName'")
	}
	if args.Zone == nil {
		return nil, errors.New("invalid value for required argument 'Zone'")
	}
	opts = internal.PkgResourceDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var resource IploadbalancingHttpFarm
	err = ctx.RegisterPackageResource("ovh:index/iploadbalancingHttpFarm:IploadbalancingHttpFarm", name, args, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// GetIploadbalancingHttpFarm gets an existing IploadbalancingHttpFarm resource's state with the given name, ID, and optional
// state properties that are used to uniquely qualify the lookup (nil if not required).
func GetIploadbalancingHttpFarm(ctx *pulumi.Context,
	name string, id pulumi.IDInput, state *IploadbalancingHttpFarmState, opts ...pulumi.ResourceOption) (*IploadbalancingHttpFarm, error) {
	var resource IploadbalancingHttpFarm
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	err = ctx.ReadPackageResource("ovh:index/iploadbalancingHttpFarm:IploadbalancingHttpFarm", name, id, state, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// Input properties used for looking up and filtering IploadbalancingHttpFarm resources.
type iploadbalancingHttpFarmState struct {
	Balance        *string                       `pulumi:"balance"`
	DisplayName    *string                       `pulumi:"displayName"`
	Port           *float64                      `pulumi:"port"`
	Probe          *IploadbalancingHttpFarmProbe `pulumi:"probe"`
	ServiceName    *string                       `pulumi:"serviceName"`
	Stickiness     *string                       `pulumi:"stickiness"`
	VrackNetworkId *float64                      `pulumi:"vrackNetworkId"`
	Zone           *string                       `pulumi:"zone"`
}

type IploadbalancingHttpFarmState struct {
	Balance        pulumi.StringPtrInput
	DisplayName    pulumi.StringPtrInput
	Port           pulumi.Float64PtrInput
	Probe          IploadbalancingHttpFarmProbePtrInput
	ServiceName    pulumi.StringPtrInput
	Stickiness     pulumi.StringPtrInput
	VrackNetworkId pulumi.Float64PtrInput
	Zone           pulumi.StringPtrInput
}

func (IploadbalancingHttpFarmState) ElementType() reflect.Type {
	return reflect.TypeOf((*iploadbalancingHttpFarmState)(nil)).Elem()
}

type iploadbalancingHttpFarmArgs struct {
	Balance        *string                       `pulumi:"balance"`
	DisplayName    *string                       `pulumi:"displayName"`
	Port           *float64                      `pulumi:"port"`
	Probe          *IploadbalancingHttpFarmProbe `pulumi:"probe"`
	ServiceName    string                        `pulumi:"serviceName"`
	Stickiness     *string                       `pulumi:"stickiness"`
	VrackNetworkId *float64                      `pulumi:"vrackNetworkId"`
	Zone           string                        `pulumi:"zone"`
}

// The set of arguments for constructing a IploadbalancingHttpFarm resource.
type IploadbalancingHttpFarmArgs struct {
	Balance        pulumi.StringPtrInput
	DisplayName    pulumi.StringPtrInput
	Port           pulumi.Float64PtrInput
	Probe          IploadbalancingHttpFarmProbePtrInput
	ServiceName    pulumi.StringInput
	Stickiness     pulumi.StringPtrInput
	VrackNetworkId pulumi.Float64PtrInput
	Zone           pulumi.StringInput
}

func (IploadbalancingHttpFarmArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*iploadbalancingHttpFarmArgs)(nil)).Elem()
}

type IploadbalancingHttpFarmInput interface {
	pulumi.Input

	ToIploadbalancingHttpFarmOutput() IploadbalancingHttpFarmOutput
	ToIploadbalancingHttpFarmOutputWithContext(ctx context.Context) IploadbalancingHttpFarmOutput
}

func (*IploadbalancingHttpFarm) ElementType() reflect.Type {
	return reflect.TypeOf((**IploadbalancingHttpFarm)(nil)).Elem()
}

func (i *IploadbalancingHttpFarm) ToIploadbalancingHttpFarmOutput() IploadbalancingHttpFarmOutput {
	return i.ToIploadbalancingHttpFarmOutputWithContext(context.Background())
}

func (i *IploadbalancingHttpFarm) ToIploadbalancingHttpFarmOutputWithContext(ctx context.Context) IploadbalancingHttpFarmOutput {
	return pulumi.ToOutputWithContext(ctx, i).(IploadbalancingHttpFarmOutput)
}

type IploadbalancingHttpFarmOutput struct{ *pulumi.OutputState }

func (IploadbalancingHttpFarmOutput) ElementType() reflect.Type {
	return reflect.TypeOf((**IploadbalancingHttpFarm)(nil)).Elem()
}

func (o IploadbalancingHttpFarmOutput) ToIploadbalancingHttpFarmOutput() IploadbalancingHttpFarmOutput {
	return o
}

func (o IploadbalancingHttpFarmOutput) ToIploadbalancingHttpFarmOutputWithContext(ctx context.Context) IploadbalancingHttpFarmOutput {
	return o
}

func (o IploadbalancingHttpFarmOutput) Balance() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarm) pulumi.StringPtrOutput { return v.Balance }).(pulumi.StringPtrOutput)
}

func (o IploadbalancingHttpFarmOutput) DisplayName() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarm) pulumi.StringPtrOutput { return v.DisplayName }).(pulumi.StringPtrOutput)
}

func (o IploadbalancingHttpFarmOutput) Port() pulumi.Float64PtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarm) pulumi.Float64PtrOutput { return v.Port }).(pulumi.Float64PtrOutput)
}

func (o IploadbalancingHttpFarmOutput) Probe() IploadbalancingHttpFarmProbePtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarm) IploadbalancingHttpFarmProbePtrOutput { return v.Probe }).(IploadbalancingHttpFarmProbePtrOutput)
}

func (o IploadbalancingHttpFarmOutput) ServiceName() pulumi.StringOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarm) pulumi.StringOutput { return v.ServiceName }).(pulumi.StringOutput)
}

func (o IploadbalancingHttpFarmOutput) Stickiness() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarm) pulumi.StringPtrOutput { return v.Stickiness }).(pulumi.StringPtrOutput)
}

func (o IploadbalancingHttpFarmOutput) VrackNetworkId() pulumi.Float64PtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarm) pulumi.Float64PtrOutput { return v.VrackNetworkId }).(pulumi.Float64PtrOutput)
}

func (o IploadbalancingHttpFarmOutput) Zone() pulumi.StringOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarm) pulumi.StringOutput { return v.Zone }).(pulumi.StringOutput)
}

func init() {
	pulumi.RegisterInputType(reflect.TypeOf((*IploadbalancingHttpFarmInput)(nil)).Elem(), &IploadbalancingHttpFarm{})
	pulumi.RegisterOutputType(IploadbalancingHttpFarmOutput{})
}

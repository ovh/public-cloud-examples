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

type IploadbalancingHttpFarmServer struct {
	pulumi.CustomResourceState

	Address              pulumi.StringOutput     `pulumi:"address"`
	Backup               pulumi.BoolPtrOutput    `pulumi:"backup"`
	Chain                pulumi.StringPtrOutput  `pulumi:"chain"`
	Cookie               pulumi.StringOutput     `pulumi:"cookie"`
	DisplayName          pulumi.StringPtrOutput  `pulumi:"displayName"`
	FarmId               pulumi.Float64Output    `pulumi:"farmId"`
	OnMarkedDown         pulumi.StringPtrOutput  `pulumi:"onMarkedDown"`
	Port                 pulumi.Float64PtrOutput `pulumi:"port"`
	Probe                pulumi.BoolPtrOutput    `pulumi:"probe"`
	ProxyProtocolVersion pulumi.StringPtrOutput  `pulumi:"proxyProtocolVersion"`
	ServiceName          pulumi.StringOutput     `pulumi:"serviceName"`
	Ssl                  pulumi.BoolPtrOutput    `pulumi:"ssl"`
	Status               pulumi.StringOutput     `pulumi:"status"`
	Weight               pulumi.Float64PtrOutput `pulumi:"weight"`
}

// NewIploadbalancingHttpFarmServer registers a new resource with the given unique name, arguments, and options.
func NewIploadbalancingHttpFarmServer(ctx *pulumi.Context,
	name string, args *IploadbalancingHttpFarmServerArgs, opts ...pulumi.ResourceOption) (*IploadbalancingHttpFarmServer, error) {
	if args == nil {
		return nil, errors.New("missing one or more required arguments")
	}

	if args.Address == nil {
		return nil, errors.New("invalid value for required argument 'Address'")
	}
	if args.FarmId == nil {
		return nil, errors.New("invalid value for required argument 'FarmId'")
	}
	if args.ServiceName == nil {
		return nil, errors.New("invalid value for required argument 'ServiceName'")
	}
	if args.Status == nil {
		return nil, errors.New("invalid value for required argument 'Status'")
	}
	opts = internal.PkgResourceDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var resource IploadbalancingHttpFarmServer
	err = ctx.RegisterPackageResource("ovh:index/iploadbalancingHttpFarmServer:IploadbalancingHttpFarmServer", name, args, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// GetIploadbalancingHttpFarmServer gets an existing IploadbalancingHttpFarmServer resource's state with the given name, ID, and optional
// state properties that are used to uniquely qualify the lookup (nil if not required).
func GetIploadbalancingHttpFarmServer(ctx *pulumi.Context,
	name string, id pulumi.IDInput, state *IploadbalancingHttpFarmServerState, opts ...pulumi.ResourceOption) (*IploadbalancingHttpFarmServer, error) {
	var resource IploadbalancingHttpFarmServer
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	err = ctx.ReadPackageResource("ovh:index/iploadbalancingHttpFarmServer:IploadbalancingHttpFarmServer", name, id, state, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// Input properties used for looking up and filtering IploadbalancingHttpFarmServer resources.
type iploadbalancingHttpFarmServerState struct {
	Address              *string  `pulumi:"address"`
	Backup               *bool    `pulumi:"backup"`
	Chain                *string  `pulumi:"chain"`
	Cookie               *string  `pulumi:"cookie"`
	DisplayName          *string  `pulumi:"displayName"`
	FarmId               *float64 `pulumi:"farmId"`
	OnMarkedDown         *string  `pulumi:"onMarkedDown"`
	Port                 *float64 `pulumi:"port"`
	Probe                *bool    `pulumi:"probe"`
	ProxyProtocolVersion *string  `pulumi:"proxyProtocolVersion"`
	ServiceName          *string  `pulumi:"serviceName"`
	Ssl                  *bool    `pulumi:"ssl"`
	Status               *string  `pulumi:"status"`
	Weight               *float64 `pulumi:"weight"`
}

type IploadbalancingHttpFarmServerState struct {
	Address              pulumi.StringPtrInput
	Backup               pulumi.BoolPtrInput
	Chain                pulumi.StringPtrInput
	Cookie               pulumi.StringPtrInput
	DisplayName          pulumi.StringPtrInput
	FarmId               pulumi.Float64PtrInput
	OnMarkedDown         pulumi.StringPtrInput
	Port                 pulumi.Float64PtrInput
	Probe                pulumi.BoolPtrInput
	ProxyProtocolVersion pulumi.StringPtrInput
	ServiceName          pulumi.StringPtrInput
	Ssl                  pulumi.BoolPtrInput
	Status               pulumi.StringPtrInput
	Weight               pulumi.Float64PtrInput
}

func (IploadbalancingHttpFarmServerState) ElementType() reflect.Type {
	return reflect.TypeOf((*iploadbalancingHttpFarmServerState)(nil)).Elem()
}

type iploadbalancingHttpFarmServerArgs struct {
	Address              string   `pulumi:"address"`
	Backup               *bool    `pulumi:"backup"`
	Chain                *string  `pulumi:"chain"`
	DisplayName          *string  `pulumi:"displayName"`
	FarmId               float64  `pulumi:"farmId"`
	OnMarkedDown         *string  `pulumi:"onMarkedDown"`
	Port                 *float64 `pulumi:"port"`
	Probe                *bool    `pulumi:"probe"`
	ProxyProtocolVersion *string  `pulumi:"proxyProtocolVersion"`
	ServiceName          string   `pulumi:"serviceName"`
	Ssl                  *bool    `pulumi:"ssl"`
	Status               string   `pulumi:"status"`
	Weight               *float64 `pulumi:"weight"`
}

// The set of arguments for constructing a IploadbalancingHttpFarmServer resource.
type IploadbalancingHttpFarmServerArgs struct {
	Address              pulumi.StringInput
	Backup               pulumi.BoolPtrInput
	Chain                pulumi.StringPtrInput
	DisplayName          pulumi.StringPtrInput
	FarmId               pulumi.Float64Input
	OnMarkedDown         pulumi.StringPtrInput
	Port                 pulumi.Float64PtrInput
	Probe                pulumi.BoolPtrInput
	ProxyProtocolVersion pulumi.StringPtrInput
	ServiceName          pulumi.StringInput
	Ssl                  pulumi.BoolPtrInput
	Status               pulumi.StringInput
	Weight               pulumi.Float64PtrInput
}

func (IploadbalancingHttpFarmServerArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*iploadbalancingHttpFarmServerArgs)(nil)).Elem()
}

type IploadbalancingHttpFarmServerInput interface {
	pulumi.Input

	ToIploadbalancingHttpFarmServerOutput() IploadbalancingHttpFarmServerOutput
	ToIploadbalancingHttpFarmServerOutputWithContext(ctx context.Context) IploadbalancingHttpFarmServerOutput
}

func (*IploadbalancingHttpFarmServer) ElementType() reflect.Type {
	return reflect.TypeOf((**IploadbalancingHttpFarmServer)(nil)).Elem()
}

func (i *IploadbalancingHttpFarmServer) ToIploadbalancingHttpFarmServerOutput() IploadbalancingHttpFarmServerOutput {
	return i.ToIploadbalancingHttpFarmServerOutputWithContext(context.Background())
}

func (i *IploadbalancingHttpFarmServer) ToIploadbalancingHttpFarmServerOutputWithContext(ctx context.Context) IploadbalancingHttpFarmServerOutput {
	return pulumi.ToOutputWithContext(ctx, i).(IploadbalancingHttpFarmServerOutput)
}

type IploadbalancingHttpFarmServerOutput struct{ *pulumi.OutputState }

func (IploadbalancingHttpFarmServerOutput) ElementType() reflect.Type {
	return reflect.TypeOf((**IploadbalancingHttpFarmServer)(nil)).Elem()
}

func (o IploadbalancingHttpFarmServerOutput) ToIploadbalancingHttpFarmServerOutput() IploadbalancingHttpFarmServerOutput {
	return o
}

func (o IploadbalancingHttpFarmServerOutput) ToIploadbalancingHttpFarmServerOutputWithContext(ctx context.Context) IploadbalancingHttpFarmServerOutput {
	return o
}

func (o IploadbalancingHttpFarmServerOutput) Address() pulumi.StringOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.StringOutput { return v.Address }).(pulumi.StringOutput)
}

func (o IploadbalancingHttpFarmServerOutput) Backup() pulumi.BoolPtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.BoolPtrOutput { return v.Backup }).(pulumi.BoolPtrOutput)
}

func (o IploadbalancingHttpFarmServerOutput) Chain() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.StringPtrOutput { return v.Chain }).(pulumi.StringPtrOutput)
}

func (o IploadbalancingHttpFarmServerOutput) Cookie() pulumi.StringOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.StringOutput { return v.Cookie }).(pulumi.StringOutput)
}

func (o IploadbalancingHttpFarmServerOutput) DisplayName() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.StringPtrOutput { return v.DisplayName }).(pulumi.StringPtrOutput)
}

func (o IploadbalancingHttpFarmServerOutput) FarmId() pulumi.Float64Output {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.Float64Output { return v.FarmId }).(pulumi.Float64Output)
}

func (o IploadbalancingHttpFarmServerOutput) OnMarkedDown() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.StringPtrOutput { return v.OnMarkedDown }).(pulumi.StringPtrOutput)
}

func (o IploadbalancingHttpFarmServerOutput) Port() pulumi.Float64PtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.Float64PtrOutput { return v.Port }).(pulumi.Float64PtrOutput)
}

func (o IploadbalancingHttpFarmServerOutput) Probe() pulumi.BoolPtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.BoolPtrOutput { return v.Probe }).(pulumi.BoolPtrOutput)
}

func (o IploadbalancingHttpFarmServerOutput) ProxyProtocolVersion() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.StringPtrOutput { return v.ProxyProtocolVersion }).(pulumi.StringPtrOutput)
}

func (o IploadbalancingHttpFarmServerOutput) ServiceName() pulumi.StringOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.StringOutput { return v.ServiceName }).(pulumi.StringOutput)
}

func (o IploadbalancingHttpFarmServerOutput) Ssl() pulumi.BoolPtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.BoolPtrOutput { return v.Ssl }).(pulumi.BoolPtrOutput)
}

func (o IploadbalancingHttpFarmServerOutput) Status() pulumi.StringOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.StringOutput { return v.Status }).(pulumi.StringOutput)
}

func (o IploadbalancingHttpFarmServerOutput) Weight() pulumi.Float64PtrOutput {
	return o.ApplyT(func(v *IploadbalancingHttpFarmServer) pulumi.Float64PtrOutput { return v.Weight }).(pulumi.Float64PtrOutput)
}

func init() {
	pulumi.RegisterInputType(reflect.TypeOf((*IploadbalancingHttpFarmServerInput)(nil)).Elem(), &IploadbalancingHttpFarmServer{})
	pulumi.RegisterOutputType(IploadbalancingHttpFarmServerOutput{})
}

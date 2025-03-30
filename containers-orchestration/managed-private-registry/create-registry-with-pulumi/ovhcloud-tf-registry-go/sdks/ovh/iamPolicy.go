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

type IamPolicy struct {
	pulumi.CustomResourceState

	Allows            pulumi.StringArrayOutput `pulumi:"allows"`
	CreatedAt         pulumi.StringOutput      `pulumi:"createdAt"`
	Denies            pulumi.StringArrayOutput `pulumi:"denies"`
	Description       pulumi.StringPtrOutput   `pulumi:"description"`
	Excepts           pulumi.StringArrayOutput `pulumi:"excepts"`
	Identities        pulumi.StringArrayOutput `pulumi:"identities"`
	Name              pulumi.StringOutput      `pulumi:"name"`
	Owner             pulumi.StringOutput      `pulumi:"owner"`
	PermissionsGroups pulumi.StringArrayOutput `pulumi:"permissionsGroups"`
	ReadOnly          pulumi.BoolOutput        `pulumi:"readOnly"`
	Resources         pulumi.StringArrayOutput `pulumi:"resources"`
	UpdatedAt         pulumi.StringOutput      `pulumi:"updatedAt"`
}

// NewIamPolicy registers a new resource with the given unique name, arguments, and options.
func NewIamPolicy(ctx *pulumi.Context,
	name string, args *IamPolicyArgs, opts ...pulumi.ResourceOption) (*IamPolicy, error) {
	if args == nil {
		return nil, errors.New("missing one or more required arguments")
	}

	if args.Identities == nil {
		return nil, errors.New("invalid value for required argument 'Identities'")
	}
	if args.Resources == nil {
		return nil, errors.New("invalid value for required argument 'Resources'")
	}
	opts = internal.PkgResourceDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var resource IamPolicy
	err = ctx.RegisterPackageResource("ovh:index/iamPolicy:IamPolicy", name, args, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// GetIamPolicy gets an existing IamPolicy resource's state with the given name, ID, and optional
// state properties that are used to uniquely qualify the lookup (nil if not required).
func GetIamPolicy(ctx *pulumi.Context,
	name string, id pulumi.IDInput, state *IamPolicyState, opts ...pulumi.ResourceOption) (*IamPolicy, error) {
	var resource IamPolicy
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	err = ctx.ReadPackageResource("ovh:index/iamPolicy:IamPolicy", name, id, state, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// Input properties used for looking up and filtering IamPolicy resources.
type iamPolicyState struct {
	Allows            []string `pulumi:"allows"`
	CreatedAt         *string  `pulumi:"createdAt"`
	Denies            []string `pulumi:"denies"`
	Description       *string  `pulumi:"description"`
	Excepts           []string `pulumi:"excepts"`
	Identities        []string `pulumi:"identities"`
	Name              *string  `pulumi:"name"`
	Owner             *string  `pulumi:"owner"`
	PermissionsGroups []string `pulumi:"permissionsGroups"`
	ReadOnly          *bool    `pulumi:"readOnly"`
	Resources         []string `pulumi:"resources"`
	UpdatedAt         *string  `pulumi:"updatedAt"`
}

type IamPolicyState struct {
	Allows            pulumi.StringArrayInput
	CreatedAt         pulumi.StringPtrInput
	Denies            pulumi.StringArrayInput
	Description       pulumi.StringPtrInput
	Excepts           pulumi.StringArrayInput
	Identities        pulumi.StringArrayInput
	Name              pulumi.StringPtrInput
	Owner             pulumi.StringPtrInput
	PermissionsGroups pulumi.StringArrayInput
	ReadOnly          pulumi.BoolPtrInput
	Resources         pulumi.StringArrayInput
	UpdatedAt         pulumi.StringPtrInput
}

func (IamPolicyState) ElementType() reflect.Type {
	return reflect.TypeOf((*iamPolicyState)(nil)).Elem()
}

type iamPolicyArgs struct {
	Allows            []string `pulumi:"allows"`
	Denies            []string `pulumi:"denies"`
	Description       *string  `pulumi:"description"`
	Excepts           []string `pulumi:"excepts"`
	Identities        []string `pulumi:"identities"`
	Name              *string  `pulumi:"name"`
	PermissionsGroups []string `pulumi:"permissionsGroups"`
	Resources         []string `pulumi:"resources"`
}

// The set of arguments for constructing a IamPolicy resource.
type IamPolicyArgs struct {
	Allows            pulumi.StringArrayInput
	Denies            pulumi.StringArrayInput
	Description       pulumi.StringPtrInput
	Excepts           pulumi.StringArrayInput
	Identities        pulumi.StringArrayInput
	Name              pulumi.StringPtrInput
	PermissionsGroups pulumi.StringArrayInput
	Resources         pulumi.StringArrayInput
}

func (IamPolicyArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*iamPolicyArgs)(nil)).Elem()
}

type IamPolicyInput interface {
	pulumi.Input

	ToIamPolicyOutput() IamPolicyOutput
	ToIamPolicyOutputWithContext(ctx context.Context) IamPolicyOutput
}

func (*IamPolicy) ElementType() reflect.Type {
	return reflect.TypeOf((**IamPolicy)(nil)).Elem()
}

func (i *IamPolicy) ToIamPolicyOutput() IamPolicyOutput {
	return i.ToIamPolicyOutputWithContext(context.Background())
}

func (i *IamPolicy) ToIamPolicyOutputWithContext(ctx context.Context) IamPolicyOutput {
	return pulumi.ToOutputWithContext(ctx, i).(IamPolicyOutput)
}

type IamPolicyOutput struct{ *pulumi.OutputState }

func (IamPolicyOutput) ElementType() reflect.Type {
	return reflect.TypeOf((**IamPolicy)(nil)).Elem()
}

func (o IamPolicyOutput) ToIamPolicyOutput() IamPolicyOutput {
	return o
}

func (o IamPolicyOutput) ToIamPolicyOutputWithContext(ctx context.Context) IamPolicyOutput {
	return o
}

func (o IamPolicyOutput) Allows() pulumi.StringArrayOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringArrayOutput { return v.Allows }).(pulumi.StringArrayOutput)
}

func (o IamPolicyOutput) CreatedAt() pulumi.StringOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringOutput { return v.CreatedAt }).(pulumi.StringOutput)
}

func (o IamPolicyOutput) Denies() pulumi.StringArrayOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringArrayOutput { return v.Denies }).(pulumi.StringArrayOutput)
}

func (o IamPolicyOutput) Description() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringPtrOutput { return v.Description }).(pulumi.StringPtrOutput)
}

func (o IamPolicyOutput) Excepts() pulumi.StringArrayOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringArrayOutput { return v.Excepts }).(pulumi.StringArrayOutput)
}

func (o IamPolicyOutput) Identities() pulumi.StringArrayOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringArrayOutput { return v.Identities }).(pulumi.StringArrayOutput)
}

func (o IamPolicyOutput) Name() pulumi.StringOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringOutput { return v.Name }).(pulumi.StringOutput)
}

func (o IamPolicyOutput) Owner() pulumi.StringOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringOutput { return v.Owner }).(pulumi.StringOutput)
}

func (o IamPolicyOutput) PermissionsGroups() pulumi.StringArrayOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringArrayOutput { return v.PermissionsGroups }).(pulumi.StringArrayOutput)
}

func (o IamPolicyOutput) ReadOnly() pulumi.BoolOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.BoolOutput { return v.ReadOnly }).(pulumi.BoolOutput)
}

func (o IamPolicyOutput) Resources() pulumi.StringArrayOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringArrayOutput { return v.Resources }).(pulumi.StringArrayOutput)
}

func (o IamPolicyOutput) UpdatedAt() pulumi.StringOutput {
	return o.ApplyT(func(v *IamPolicy) pulumi.StringOutput { return v.UpdatedAt }).(pulumi.StringOutput)
}

func init() {
	pulumi.RegisterInputType(reflect.TypeOf((*IamPolicyInput)(nil)).Elem(), &IamPolicy{})
	pulumi.RegisterOutputType(IamPolicyOutput{})
}

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

type CloudProjectDatabaseOpensearchPattern struct {
	pulumi.CustomResourceState

	// Id of the database cluster
	ClusterId pulumi.StringOutput `pulumi:"clusterId"`
	// Maximum number of index for this pattern
	MaxIndexCount pulumi.Float64PtrOutput `pulumi:"maxIndexCount"`
	// Pattern format
	Pattern     pulumi.StringOutput                                    `pulumi:"pattern"`
	ServiceName pulumi.StringPtrOutput                                 `pulumi:"serviceName"`
	Timeouts    CloudProjectDatabaseOpensearchPatternTimeoutsPtrOutput `pulumi:"timeouts"`
}

// NewCloudProjectDatabaseOpensearchPattern registers a new resource with the given unique name, arguments, and options.
func NewCloudProjectDatabaseOpensearchPattern(ctx *pulumi.Context,
	name string, args *CloudProjectDatabaseOpensearchPatternArgs, opts ...pulumi.ResourceOption) (*CloudProjectDatabaseOpensearchPattern, error) {
	if args == nil {
		return nil, errors.New("missing one or more required arguments")
	}

	if args.ClusterId == nil {
		return nil, errors.New("invalid value for required argument 'ClusterId'")
	}
	if args.Pattern == nil {
		return nil, errors.New("invalid value for required argument 'Pattern'")
	}
	opts = internal.PkgResourceDefaultOpts(opts)
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	var resource CloudProjectDatabaseOpensearchPattern
	err = ctx.RegisterPackageResource("ovh:index/cloudProjectDatabaseOpensearchPattern:CloudProjectDatabaseOpensearchPattern", name, args, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// GetCloudProjectDatabaseOpensearchPattern gets an existing CloudProjectDatabaseOpensearchPattern resource's state with the given name, ID, and optional
// state properties that are used to uniquely qualify the lookup (nil if not required).
func GetCloudProjectDatabaseOpensearchPattern(ctx *pulumi.Context,
	name string, id pulumi.IDInput, state *CloudProjectDatabaseOpensearchPatternState, opts ...pulumi.ResourceOption) (*CloudProjectDatabaseOpensearchPattern, error) {
	var resource CloudProjectDatabaseOpensearchPattern
	ref, err := internal.PkgGetPackageRef(ctx)
	if err != nil {
		return nil, err
	}
	err = ctx.ReadPackageResource("ovh:index/cloudProjectDatabaseOpensearchPattern:CloudProjectDatabaseOpensearchPattern", name, id, state, &resource, ref, opts...)
	if err != nil {
		return nil, err
	}
	return &resource, nil
}

// Input properties used for looking up and filtering CloudProjectDatabaseOpensearchPattern resources.
type cloudProjectDatabaseOpensearchPatternState struct {
	// Id of the database cluster
	ClusterId *string `pulumi:"clusterId"`
	// Maximum number of index for this pattern
	MaxIndexCount *float64 `pulumi:"maxIndexCount"`
	// Pattern format
	Pattern     *string                                        `pulumi:"pattern"`
	ServiceName *string                                        `pulumi:"serviceName"`
	Timeouts    *CloudProjectDatabaseOpensearchPatternTimeouts `pulumi:"timeouts"`
}

type CloudProjectDatabaseOpensearchPatternState struct {
	// Id of the database cluster
	ClusterId pulumi.StringPtrInput
	// Maximum number of index for this pattern
	MaxIndexCount pulumi.Float64PtrInput
	// Pattern format
	Pattern     pulumi.StringPtrInput
	ServiceName pulumi.StringPtrInput
	Timeouts    CloudProjectDatabaseOpensearchPatternTimeoutsPtrInput
}

func (CloudProjectDatabaseOpensearchPatternState) ElementType() reflect.Type {
	return reflect.TypeOf((*cloudProjectDatabaseOpensearchPatternState)(nil)).Elem()
}

type cloudProjectDatabaseOpensearchPatternArgs struct {
	// Id of the database cluster
	ClusterId string `pulumi:"clusterId"`
	// Maximum number of index for this pattern
	MaxIndexCount *float64 `pulumi:"maxIndexCount"`
	// Pattern format
	Pattern     string                                         `pulumi:"pattern"`
	ServiceName *string                                        `pulumi:"serviceName"`
	Timeouts    *CloudProjectDatabaseOpensearchPatternTimeouts `pulumi:"timeouts"`
}

// The set of arguments for constructing a CloudProjectDatabaseOpensearchPattern resource.
type CloudProjectDatabaseOpensearchPatternArgs struct {
	// Id of the database cluster
	ClusterId pulumi.StringInput
	// Maximum number of index for this pattern
	MaxIndexCount pulumi.Float64PtrInput
	// Pattern format
	Pattern     pulumi.StringInput
	ServiceName pulumi.StringPtrInput
	Timeouts    CloudProjectDatabaseOpensearchPatternTimeoutsPtrInput
}

func (CloudProjectDatabaseOpensearchPatternArgs) ElementType() reflect.Type {
	return reflect.TypeOf((*cloudProjectDatabaseOpensearchPatternArgs)(nil)).Elem()
}

type CloudProjectDatabaseOpensearchPatternInput interface {
	pulumi.Input

	ToCloudProjectDatabaseOpensearchPatternOutput() CloudProjectDatabaseOpensearchPatternOutput
	ToCloudProjectDatabaseOpensearchPatternOutputWithContext(ctx context.Context) CloudProjectDatabaseOpensearchPatternOutput
}

func (*CloudProjectDatabaseOpensearchPattern) ElementType() reflect.Type {
	return reflect.TypeOf((**CloudProjectDatabaseOpensearchPattern)(nil)).Elem()
}

func (i *CloudProjectDatabaseOpensearchPattern) ToCloudProjectDatabaseOpensearchPatternOutput() CloudProjectDatabaseOpensearchPatternOutput {
	return i.ToCloudProjectDatabaseOpensearchPatternOutputWithContext(context.Background())
}

func (i *CloudProjectDatabaseOpensearchPattern) ToCloudProjectDatabaseOpensearchPatternOutputWithContext(ctx context.Context) CloudProjectDatabaseOpensearchPatternOutput {
	return pulumi.ToOutputWithContext(ctx, i).(CloudProjectDatabaseOpensearchPatternOutput)
}

type CloudProjectDatabaseOpensearchPatternOutput struct{ *pulumi.OutputState }

func (CloudProjectDatabaseOpensearchPatternOutput) ElementType() reflect.Type {
	return reflect.TypeOf((**CloudProjectDatabaseOpensearchPattern)(nil)).Elem()
}

func (o CloudProjectDatabaseOpensearchPatternOutput) ToCloudProjectDatabaseOpensearchPatternOutput() CloudProjectDatabaseOpensearchPatternOutput {
	return o
}

func (o CloudProjectDatabaseOpensearchPatternOutput) ToCloudProjectDatabaseOpensearchPatternOutputWithContext(ctx context.Context) CloudProjectDatabaseOpensearchPatternOutput {
	return o
}

// Id of the database cluster
func (o CloudProjectDatabaseOpensearchPatternOutput) ClusterId() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectDatabaseOpensearchPattern) pulumi.StringOutput { return v.ClusterId }).(pulumi.StringOutput)
}

// Maximum number of index for this pattern
func (o CloudProjectDatabaseOpensearchPatternOutput) MaxIndexCount() pulumi.Float64PtrOutput {
	return o.ApplyT(func(v *CloudProjectDatabaseOpensearchPattern) pulumi.Float64PtrOutput { return v.MaxIndexCount }).(pulumi.Float64PtrOutput)
}

// Pattern format
func (o CloudProjectDatabaseOpensearchPatternOutput) Pattern() pulumi.StringOutput {
	return o.ApplyT(func(v *CloudProjectDatabaseOpensearchPattern) pulumi.StringOutput { return v.Pattern }).(pulumi.StringOutput)
}

func (o CloudProjectDatabaseOpensearchPatternOutput) ServiceName() pulumi.StringPtrOutput {
	return o.ApplyT(func(v *CloudProjectDatabaseOpensearchPattern) pulumi.StringPtrOutput { return v.ServiceName }).(pulumi.StringPtrOutput)
}

func (o CloudProjectDatabaseOpensearchPatternOutput) Timeouts() CloudProjectDatabaseOpensearchPatternTimeoutsPtrOutput {
	return o.ApplyT(func(v *CloudProjectDatabaseOpensearchPattern) CloudProjectDatabaseOpensearchPatternTimeoutsPtrOutput {
		return v.Timeouts
	}).(CloudProjectDatabaseOpensearchPatternTimeoutsPtrOutput)
}

func init() {
	pulumi.RegisterInputType(reflect.TypeOf((*CloudProjectDatabaseOpensearchPatternInput)(nil)).Elem(), &CloudProjectDatabaseOpensearchPattern{})
	pulumi.RegisterOutputType(CloudProjectDatabaseOpensearchPatternOutput{})
}

//
//  Board.m
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

#import "Board.h"
#import "Image.h"

struct BoardDirtyProperties {
    unsigned int BoardDirtyPropertyCounts:1;
    unsigned int BoardDirtyPropertyCreatedAt:1;
    unsigned int BoardDirtyPropertyCreator:1;
    unsigned int BoardDirtyPropertyDescriptionText:1;
    unsigned int BoardDirtyPropertyIdentifier:1;
    unsigned int BoardDirtyPropertyImage:1;
    unsigned int BoardDirtyPropertyName:1;
    unsigned int BoardDirtyPropertyUrl:1;
};

@interface Board ()
@property (nonatomic, assign, readwrite) struct BoardDirtyProperties boardDirtyProperties;
@end

@interface BoardBuilder ()
@property (nonatomic, assign, readwrite) struct BoardDirtyProperties boardDirtyProperties;
@end

@implementation Board
+ (NSString *)className
{
    return @"Board";
}
+ (NSString *)polymorphicTypeIdentifier
{
    return @"board";
}
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithModelDictionary:dictionary];
}
- (instancetype)init
{
    return [self initWithModelDictionary:@{}];
}
- (instancetype)initWithModelDictionary:(NS_VALID_UNTIL_END_OF_SCOPE NSDictionary *)modelDictionary
{
    NSParameterAssert(modelDictionary);
    if (!(self = [super init])) {
        return self;
    }
        {
            __unsafe_unretained id value = modelDictionary[@"name"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_name = [value copy];
                }
                self->_boardDirtyProperties.BoardDirtyPropertyName = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"id"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_identifier = [value copy];
                }
                self->_boardDirtyProperties.BoardDirtyPropertyIdentifier = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"image"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_image = [Image modelObjectWithDictionary:value];
                }
                self->_boardDirtyProperties.BoardDirtyPropertyImage = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"counts"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_counts = value;
                }
                self->_boardDirtyProperties.BoardDirtyPropertyCounts = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"created_at"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_createdAt = [[NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey] transformedValue:value];
                }
                self->_boardDirtyProperties.BoardDirtyPropertyCreatedAt = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"description"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_descriptionText = [value copy];
                }
                self->_boardDirtyProperties.BoardDirtyPropertyDescriptionText = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"creator"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    NSDictionary *items0 = value;
                    NSMutableDictionary *result0 = [NSMutableDictionary dictionaryWithCapacity:items0.count];
                    [items0 enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key0, id  _Nonnull obj0, __unused BOOL * _Nonnull stop0){
                        if (obj0 != nil && obj0 != (id)kCFNull) {
                            result0[key0] = [obj0 copy];
                        }
                    }];
                    self->_creator = result0;
                }
                self->_boardDirtyProperties.BoardDirtyPropertyCreator = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"url"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_url = [NSURL URLWithString:value];
                }
                self->_boardDirtyProperties.BoardDirtyPropertyUrl = 1;
            }
        }
    if ([self class] == [Board class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (instancetype)initWithBuilder:(BoardBuilder *)builder
{
    NSParameterAssert(builder);
    return [self initWithBuilder:builder initType:PlankModelInitTypeDefault];
}
- (instancetype)initWithBuilder:(BoardBuilder *)builder initType:(PlankModelInitType)initType
{
    NSParameterAssert(builder);
    if (!(self = [super init])) {
        return self;
    }
    _name = builder.name;
    _identifier = builder.identifier;
    _image = builder.image;
    _counts = builder.counts;
    _createdAt = builder.createdAt;
    _descriptionText = builder.descriptionText;
    _creator = builder.creator;
    _url = builder.url;
    _boardDirtyProperties = builder.boardDirtyProperties;
    if ([self class] == [Board class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(initType) }];
    }
    return self;
}
- (NSString *)debugDescription
{
    NSArray<NSString *> *parentDebugDescription = [[super debugDescription] componentsSeparatedByString:@"\n"];
    NSMutableArray *descriptionFields = [NSMutableArray arrayWithCapacity:8];
    [descriptionFields addObject:parentDebugDescription];
    struct BoardDirtyProperties props = _boardDirtyProperties;
    if (props.BoardDirtyPropertyName) {
        [descriptionFields addObject:[@"_name = " stringByAppendingFormat:@"%@", _name]];
    }
    if (props.BoardDirtyPropertyIdentifier) {
        [descriptionFields addObject:[@"_identifier = " stringByAppendingFormat:@"%@", _identifier]];
    }
    if (props.BoardDirtyPropertyImage) {
        [descriptionFields addObject:[@"_image = " stringByAppendingFormat:@"%@", _image]];
    }
    if (props.BoardDirtyPropertyCounts) {
        [descriptionFields addObject:[@"_counts = " stringByAppendingFormat:@"%@", _counts]];
    }
    if (props.BoardDirtyPropertyCreatedAt) {
        [descriptionFields addObject:[@"_createdAt = " stringByAppendingFormat:@"%@", _createdAt]];
    }
    if (props.BoardDirtyPropertyDescriptionText) {
        [descriptionFields addObject:[@"_descriptionText = " stringByAppendingFormat:@"%@", _descriptionText]];
    }
    if (props.BoardDirtyPropertyCreator) {
        [descriptionFields addObject:[@"_creator = " stringByAppendingFormat:@"%@", _creator]];
    }
    if (props.BoardDirtyPropertyUrl) {
        [descriptionFields addObject:[@"_url = " stringByAppendingFormat:@"%@", _url]];
    }
    return [NSString stringWithFormat:@"Board = {\n%@\n}", debugDescriptionForFields(descriptionFields)];
}
- (instancetype)copyWithBlock:(PLANK_NOESCAPE void (^)(BoardBuilder *builder))block
{
    NSParameterAssert(block);
    BoardBuilder *builder = [[BoardBuilder alloc] initWithModel:self];
    block(builder);
    return [builder build];
}
- (BOOL)isEqual:(id)anObject
{
    if (self == anObject) {
        return YES;
    }
    if ([anObject isKindOfClass:[Board class]] == NO) {
        return NO;
    }
    return [self isEqualToBoard:anObject];
}
- (BOOL)isEqualToBoard:(Board *)anObject
{
    return (
        (anObject != nil) &&
        (_name == anObject.name || [_name isEqualToString:anObject.name]) &&
        (_identifier == anObject.identifier || [_identifier isEqualToString:anObject.identifier]) &&
        (_image == anObject.image || [_image isEqual:anObject.image]) &&
        (_counts == anObject.counts || [_counts isEqualToDictionary:anObject.counts]) &&
        (_createdAt == anObject.createdAt || [_createdAt isEqualToDate:anObject.createdAt]) &&
        (_descriptionText == anObject.descriptionText || [_descriptionText isEqualToString:anObject.descriptionText]) &&
        (_creator == anObject.creator || [_creator isEqualToDictionary:anObject.creator]) &&
        (_url == anObject.url || [_url isEqual:anObject.url])
    );
}
- (NSUInteger)hash
{
    NSUInteger subhashes[] = {
        17,
        [_name hash],
        [_identifier hash],
        [_image hash],
        [_counts hash],
        [_createdAt hash],
        [_descriptionText hash],
        [_creator hash],
        [_url hash]
    };
    return PINIntegerArrayHash(subhashes, sizeof(subhashes) / sizeof(subhashes[0]));
}
- (instancetype)mergeWithModel:(Board *)modelObject
{
    return [self mergeWithModel:modelObject initType:PlankModelInitTypeFromMerge];
}
- (instancetype)mergeWithModel:(Board *)modelObject initType:(PlankModelInitType)initType
{
    NSParameterAssert(modelObject);
    BoardBuilder *builder = [[BoardBuilder alloc] initWithModel:self];
    [builder mergeWithModel:modelObject];
    return [[Board alloc] initWithBuilder:builder initType:initType];
}
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:8];
    if (_boardDirtyProperties.BoardDirtyPropertyName) {
        if (_name != nil) {
            [dict setObject:_name forKey:@"name"];
        }
         else {
            [dict setObject:[NSNull null] forKey:@"name"];
        }
    }
    if (_boardDirtyProperties.BoardDirtyPropertyIdentifier) {
        if (_identifier != nil) {
            [dict setObject:_identifier forKey:@"id"];
        }
         else {
            [dict setObject:[NSNull null] forKey:@"id"];
        }
    }
    if (_boardDirtyProperties.BoardDirtyPropertyImage) {
        if (_image != nil) {
            [dict setObject:[_image dictionaryRepresentation] forKey:@"image"];
        }
         else {
            [dict setObject:[NSNull null] forKey:@"image"];
        }
    }
    if (_boardDirtyProperties.BoardDirtyPropertyCounts) {
        if (_counts != nil) {
            [dict setObject:_counts forKey:@"counts"];
        }
         else {
            [dict setObject:[NSNull null] forKey:@"counts"];
        }
    }
    if (_boardDirtyProperties.BoardDirtyPropertyCreatedAt) {
        if (_createdAt != nil && [NSValueTransformer allowsReverseTransformation]) {
            [dict setObject:[[NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey] reverseTransformedValue:_createdAt] forKey:@"created_at"];
        }
         else {
            [dict setObject:[NSNull null] forKey:@"created_at"];
        }
    }
    if (_boardDirtyProperties.BoardDirtyPropertyDescriptionText) {
        if (_descriptionText != nil) {
            [dict setObject:_descriptionText forKey:@"description"];
        }
         else {
            [dict setObject:[NSNull null] forKey:@"description"];
        }
    }
    if (_boardDirtyProperties.BoardDirtyPropertyCreator) {
        if (_creator != nil) {
            [dict setObject:_creator forKey:@"creator"];
        }
         else {
            [dict setObject:[NSNull null] forKey:@"creator"];
        }
    }
    if (_boardDirtyProperties.BoardDirtyPropertyUrl) {
        if (_url != nil) {
            [dict setObject:[_url absoluteString] forKey:@"url"];
        }
         else {
            [dict setObject:[NSNull null] forKey:@"url"];
        }
    }
    return dict;
}
#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding
{
    return YES;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super init])) {
        return self;
    }
    _name = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"name"];
    _identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"id"];
    _image = [aDecoder decodeObjectOfClass:[Image class] forKey:@"image"];
    _counts = [aDecoder decodeObjectOfClasses:[NSSet setWithArray:@[[NSDictionary class], [NSNumber class]]] forKey:@"counts"];
    _createdAt = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"created_at"];
    _descriptionText = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"description"];
    _creator = [aDecoder decodeObjectOfClasses:[NSSet setWithArray:@[[NSDictionary class], [NSString class]]] forKey:@"creator"];
    _url = [aDecoder decodeObjectOfClass:[NSURL class] forKey:@"url"];
    _boardDirtyProperties.BoardDirtyPropertyName = [aDecoder decodeIntForKey:@"name_dirty_property"] & 0x1;
    _boardDirtyProperties.BoardDirtyPropertyIdentifier = [aDecoder decodeIntForKey:@"id_dirty_property"] & 0x1;
    _boardDirtyProperties.BoardDirtyPropertyImage = [aDecoder decodeIntForKey:@"image_dirty_property"] & 0x1;
    _boardDirtyProperties.BoardDirtyPropertyCounts = [aDecoder decodeIntForKey:@"counts_dirty_property"] & 0x1;
    _boardDirtyProperties.BoardDirtyPropertyCreatedAt = [aDecoder decodeIntForKey:@"created_at_dirty_property"] & 0x1;
    _boardDirtyProperties.BoardDirtyPropertyDescriptionText = [aDecoder decodeIntForKey:@"description_dirty_property"] & 0x1;
    _boardDirtyProperties.BoardDirtyPropertyCreator = [aDecoder decodeIntForKey:@"creator_dirty_property"] & 0x1;
    _boardDirtyProperties.BoardDirtyPropertyUrl = [aDecoder decodeIntForKey:@"url_dirty_property"] & 0x1;
    if ([self class] == [Board class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.identifier forKey:@"id"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.counts forKey:@"counts"];
    [aCoder encodeObject:self.createdAt forKey:@"created_at"];
    [aCoder encodeObject:self.descriptionText forKey:@"description"];
    [aCoder encodeObject:self.creator forKey:@"creator"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeInt:_boardDirtyProperties.BoardDirtyPropertyName forKey:@"name_dirty_property"];
    [aCoder encodeInt:_boardDirtyProperties.BoardDirtyPropertyIdentifier forKey:@"id_dirty_property"];
    [aCoder encodeInt:_boardDirtyProperties.BoardDirtyPropertyImage forKey:@"image_dirty_property"];
    [aCoder encodeInt:_boardDirtyProperties.BoardDirtyPropertyCounts forKey:@"counts_dirty_property"];
    [aCoder encodeInt:_boardDirtyProperties.BoardDirtyPropertyCreatedAt forKey:@"created_at_dirty_property"];
    [aCoder encodeInt:_boardDirtyProperties.BoardDirtyPropertyDescriptionText forKey:@"description_dirty_property"];
    [aCoder encodeInt:_boardDirtyProperties.BoardDirtyPropertyCreator forKey:@"creator_dirty_property"];
    [aCoder encodeInt:_boardDirtyProperties.BoardDirtyPropertyUrl forKey:@"url_dirty_property"];
}
@end

@implementation BoardBuilder
- (instancetype)initWithModel:(Board *)modelObject
{
    NSParameterAssert(modelObject);
    if (!(self = [super init])) {
        return self;
    }
    struct BoardDirtyProperties boardDirtyProperties = modelObject.boardDirtyProperties;
    if (boardDirtyProperties.BoardDirtyPropertyName) {
        _name = modelObject.name;
    }
    if (boardDirtyProperties.BoardDirtyPropertyIdentifier) {
        _identifier = modelObject.identifier;
    }
    if (boardDirtyProperties.BoardDirtyPropertyImage) {
        _image = modelObject.image;
    }
    if (boardDirtyProperties.BoardDirtyPropertyCounts) {
        _counts = modelObject.counts;
    }
    if (boardDirtyProperties.BoardDirtyPropertyCreatedAt) {
        _createdAt = modelObject.createdAt;
    }
    if (boardDirtyProperties.BoardDirtyPropertyDescriptionText) {
        _descriptionText = modelObject.descriptionText;
    }
    if (boardDirtyProperties.BoardDirtyPropertyCreator) {
        _creator = modelObject.creator;
    }
    if (boardDirtyProperties.BoardDirtyPropertyUrl) {
        _url = modelObject.url;
    }
    _boardDirtyProperties = boardDirtyProperties;
    return self;
}
- (Board *)build
{
    return [[Board alloc] initWithBuilder:self];
}
- (void)mergeWithModel:(Board *)modelObject
{
    NSParameterAssert(modelObject);
    BoardBuilder *builder = self;
    if (modelObject.boardDirtyProperties.BoardDirtyPropertyName) {
        builder.name = modelObject.name;
    }
    if (modelObject.boardDirtyProperties.BoardDirtyPropertyIdentifier) {
        builder.identifier = modelObject.identifier;
    }
    if (modelObject.boardDirtyProperties.BoardDirtyPropertyImage) {
        id value = modelObject.image;
        if (value != nil) {
            if (builder.image) {
                builder.image = [builder.image mergeWithModel:value initType:PlankModelInitTypeFromSubmerge];
            } else {
                builder.image = value;
            }
        } else {
            builder.image = nil;
        }
    }
    if (modelObject.boardDirtyProperties.BoardDirtyPropertyCounts) {
        builder.counts = modelObject.counts;
    }
    if (modelObject.boardDirtyProperties.BoardDirtyPropertyCreatedAt) {
        builder.createdAt = modelObject.createdAt;
    }
    if (modelObject.boardDirtyProperties.BoardDirtyPropertyDescriptionText) {
        builder.descriptionText = modelObject.descriptionText;
    }
    if (modelObject.boardDirtyProperties.BoardDirtyPropertyCreator) {
        builder.creator = modelObject.creator;
    }
    if (modelObject.boardDirtyProperties.BoardDirtyPropertyUrl) {
        builder.url = modelObject.url;
    }
}
- (void)setName:(NSString *)name
{
    _name = name;
    _boardDirtyProperties.BoardDirtyPropertyName = 1;
}
- (void)setIdentifier:(NSString *)identifier
{
    _identifier = identifier;
    _boardDirtyProperties.BoardDirtyPropertyIdentifier = 1;
}
- (void)setImage:(Image *)image
{
    _image = image;
    _boardDirtyProperties.BoardDirtyPropertyImage = 1;
}
- (void)setCounts:(NSDictionary<NSString *, NSNumber /* Integer */ *> *)counts
{
    _counts = counts;
    _boardDirtyProperties.BoardDirtyPropertyCounts = 1;
}
- (void)setCreatedAt:(NSDate *)createdAt
{
    _createdAt = createdAt;
    _boardDirtyProperties.BoardDirtyPropertyCreatedAt = 1;
}
- (void)setDescriptionText:(NSString *)descriptionText
{
    _descriptionText = descriptionText;
    _boardDirtyProperties.BoardDirtyPropertyDescriptionText = 1;
}
- (void)setCreator:(NSDictionary<NSString *, NSString *> *)creator
{
    _creator = creator;
    _boardDirtyProperties.BoardDirtyPropertyCreator = 1;
}
- (void)setUrl:(NSURL *)url
{
    _url = url;
    _boardDirtyProperties.BoardDirtyPropertyUrl = 1;
}
@end

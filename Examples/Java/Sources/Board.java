//
//  Board.java
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

package com.pinterest.models;

@AutoValue
public abstract class Board {
    public abstract Optional<String> name();
    public abstract Optional<String> identifier();
    public abstract Image image();
    public abstract Optional<Map<String, Integer>> counts();
    public abstract Optional<Date> createdAt();
    public abstract Optional<Set<User>> contributors();
    public abstract Optional<String> descriptionText();
    public abstract Optional<Map<String, String>> creator();
    public abstract Optional<URI> url();
    public static Builder builder() {
        return new AutoValue_Board.Builder();
    }
    abstract Builder toBuilder();
    @AutoValue.Builder
    public abstract class Builder {
        public abstract Builder setName(Optional<String> value);
        public abstract Builder setIdentifier(Optional<String> value);
        public abstract Builder setImage(Image value);
        public abstract Builder setCounts(Optional<Map<String, Integer>> value);
        public abstract Builder setCreatedAt(Optional<Date> value);
        public abstract Builder setContributors(Optional<Set<User>> value);
        public abstract Builder setDescriptionText(Optional<String> value);
        public abstract Builder setCreator(Optional<Map<String, String>> value);
        public abstract Builder setUrl(Optional<URI> value);
        public abstract Builder setName(String value);
        public abstract Builder setIdentifier(String value);
        public abstract Builder setCounts(Map<String, Integer> value);
        public abstract Builder setCreatedAt(Date value);
        public abstract Builder setContributors(Set<User> value);
        public abstract Builder setDescriptionText(String value);
        public abstract Builder setCreator(Map<String, String> value);
        public abstract Builder setUrl(URI value);
        public abstract Animal build();
    
    }
}

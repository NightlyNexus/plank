//
//  User.java
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

package com.pinterest.models;

import android.support.annotation.IntDef;
import com.google.auto.value.AutoValue;
import java.util.Optional;
import java.util.Set;
import java.net.URI;
import android.support.annotation.StringDef;
import java.lang.annotation.Retention;
import java.util.Date;
import java.util.List;
import java.lang.annotation.RetentionPolicy;
import java.util.Map;

@AutoValue
public abstract class User {
    public static final String UNSET = "unset";
    public static final String IMMEDIATE = "immediate";
    public static final String DAILY = "daily";
    @StringDef({UNSET, IMMEDIATE, DAILY})
    @Retention(RetentionPolicy.SOURCE)
    public @interface UserEmailIntervalType {}
    public abstract Optional<@UserEmailIntervalType String> emailInterval();
    public abstract Optional<String> lastName();
    public abstract Optional<String> identifier();
    public abstract Optional<Image> image();
    public abstract Optional<Map<String, Integer>> counts();
    public abstract Optional<Date> createdAt();
    public abstract Optional<String> firstName();
    public abstract Optional<String> bio();
    public abstract Optional<String> username();
    public static Builder builder() {
        return new AutoValue_User.Builder();
    }
    abstract Builder toBuilder();
    @AutoValue.Builder
    public abstract static class Builder {
    
        public abstract Builder setEmailInterval(Optional<@UserEmailIntervalType String> value);
        public abstract Builder setLastName(Optional<String> value);
        public abstract Builder setIdentifier(Optional<String> value);
        public abstract Builder setImage(Optional<Image> value);
        public abstract Builder setCounts(Optional<Map<String, Integer>> value);
        public abstract Builder setCreatedAt(Optional<Date> value);
        public abstract Builder setFirstName(Optional<String> value);
        public abstract Builder setBio(Optional<String> value);
        public abstract Builder setUsername(Optional<String> value);
        public abstract Builder setEmailInterval(@UserEmailIntervalType String value);
        public abstract Builder setLastName(String value);
        public abstract Builder setIdentifier(String value);
        public abstract Builder setImage(Image value);
        public abstract Builder setCounts(Map<String, Integer> value);
        public abstract Builder setCreatedAt(Date value);
        public abstract Builder setFirstName(String value);
        public abstract Builder setBio(String value);
        public abstract Builder setUsername(String value);
        public abstract User build();
    
    }
}

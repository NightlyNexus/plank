//
// Model.java
// Autogenerated by plank
//
// DO NOT EDIT - EDITS WILL BE OVERWRITTEN
// @generated
//

package com.pinterest.models;

import android.support.annotation.IntDef;
import com.google.auto.value.AutoValue;
import java.net.URI;
import java.util.Set;
import android.support.annotation.Nullable;
import android.support.annotation.StringDef;
import java.lang.annotation.Retention;
import java.util.Date;
import java.util.List;
import java.lang.annotation.RetentionPolicy;
import java.util.Map;

@AutoValue
public abstract class Model {


    public abstract @SerializedName("id") @Nullable String identifier();
    public static Builder builder() {
        return new AutoValue_Model.Builder();
    }
    abstract Builder toBuilder();
    @AutoValue.Builder
    public abstract static class Builder {
    
    
        public abstract Builder setIdentifier(@Nullable String value);
        public abstract Model build();
    
    }
}

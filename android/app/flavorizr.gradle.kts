import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "id.smartInterviewAi.dev"
            resValue(type = "string", name = "app_name", value = "Tulkun dev")
        }
        create("uat") {
            dimension = "flavor-type"
            applicationId = "id.smartInterviewAi.uat"
            resValue(type = "string", name = "app_name", value = "Tulkun uat")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "id.smartInterviewAi"
            resValue(type = "string", name = "app_name", value = "Tulkun")
        }
    }
}
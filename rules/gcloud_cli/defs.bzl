load("//rules/gcloud_cli/private:gcloud_register_toolchains.bzl", _gcloud_cli_register_toolchains="gcloud_cli_register_toolchains")
load("//rules/gcloud_cli/private/gcloud_upload:gcloud_upload.bzl", _gcloud_upload="gcloud_upload")

gcloud_cli_register_toolchains = _gcloud_cli_register_toolchains
gcloud_upload=_gcloud_upload

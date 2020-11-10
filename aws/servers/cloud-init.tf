data "template_cloudinit_config" "cloud_init" {
    part {
      filename     = "01-start-rs-api.sh"
      content_type = "text/x-shellscript"
      content      = "#!/usr/bin/env bash\n\ndocker run -d -p 3000:3000 474307705618.dkr.ecr.eu-north-1.amazonaws.com/mdinos-images:rs-api-latest"
  }
}
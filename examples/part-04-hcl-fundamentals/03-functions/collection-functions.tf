# Collection Functions
# Part 4: HCL Fundamentals

terraform {
  required_version = ">= 1.6.0"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "default_tags" {
  type = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

variable "custom_tags" {
  type = map(string)
  default = {
    Project = "webapp"
    Team    = "platform"
  }
}

locals {
  # length() - Count elements
  az_count = length(var.availability_zones)
  tag_count = length(var.default_tags)

  # merge() - Combine maps
  all_tags = merge(var.default_tags, var.custom_tags)

  # concat() - Combine lists
  all_zones = concat(var.availability_zones, ["us-west-2d"])

  # lookup() - Safe map access with default
  environment = lookup(var.default_tags, "Environment", "unknown")
  missing_key = lookup(var.default_tags, "NonExistent", "default-value")

  # keys() / values() - Extract from map
  tag_keys = keys(var.default_tags)
  tag_values = values(var.default_tags)

  # contains() - Check membership
  has_west_2a = contains(var.availability_zones, "us-west-2a")
  has_east_1a = contains(var.availability_zones, "us-east-1a")

  # distinct() - Remove duplicates
  zones_with_dupes = ["us-west-2a", "us-west-2b", "us-west-2a"]
  unique_zones = distinct(local.zones_with_dupes)

  # sort() - Alphabetical sorting
  sorted_zones = sort(var.availability_zones)

  # reverse() - Reverse list
  reversed_zones = reverse(var.availability_zones)

  # slice() - Extract sublist
  first_two_zones = slice(var.availability_zones, 0, 2)

  # element() - Access by index (wrapping)
  first_zone = element(var.availability_zones, 0)
  wrapped_zone = element(var.availability_zones, 5)  # Wraps around

  # compact() - Remove null/empty values
  zones_with_nulls = ["us-west-2a", "", null, "us-west-2b"]
  compact_zones = compact(local.zones_with_nulls)
}

output "collection_function_examples" {
  description = "Demonstrate collection functions"
  value = {
    # Length operations
    az_count   = local.az_count
    tag_count  = local.tag_count

    # Merge operations
    default_tags = var.default_tags
    custom_tags  = var.custom_tags
    merged_tags  = local.all_tags

    # List operations
    original_zones  = var.availability_zones
    concatenated    = local.all_zones
    unique_zones    = local.unique_zones
    sorted_zones    = local.sorted_zones
    reversed_zones  = local.reversed_zones
    first_two_zones = local.first_two_zones

    # Lookup operations
    environment_tag = local.environment
    missing_key_default = local.missing_key

    # Contains operations
    has_west_2a = local.has_west_2a
    has_east_1a = local.has_east_1a

    # Element access
    first_zone_direct = local.first_zone
    wrapped_element = local.wrapped_zone

    # Map operations
    all_tag_keys   = local.tag_keys
    all_tag_values = local.tag_values
  }
}

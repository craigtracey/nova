#
# Cookbook Name:: nova
# Recipe:: conductor
#
# Copyright 2013, Craig Tracey <craigtracey@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "nova::nova-common"
include_recipe "nova::api-metadata"
include_recipe "nova::network"

platform_options = node["nova"]["platform"]
nova_compute_packages = platform_options["nova_conductor_packages"]

nova_compute_packages.each do |pkg|
  package pkg do
    action :install
    options platform_options["package_overrides"]
  end
end

service "nova-conductor" do
  service_name platform_options["nova_conductor_service"]
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, "template[/etc/nova/nova.conf]"
end

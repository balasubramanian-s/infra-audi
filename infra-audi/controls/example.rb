# copyright: 2018, The Authors

title "Sample Section"

aws_vpc_id = input("aws_vpc_id")

# You add controls here
control "aws-single-vpc-exists-check" do                                    # A unique ID for this control.
  only_if { aws_vpc_id != "" }                                              # Only run this control if the `aws_vpc_id` input is provided.
  impact 1.0                                                                # The criticality, if this control fails.
  title "Check to see if custom VPC exists."                                # A human-readable title.
  describe aws_vpc(aws_vpc_id) do                                           # The test itself.
    it { should exist }
  end
end

# s3
control 'aws-s3-buckets-1.0' do
  impact 1.0
  title 'Ensure AWS S3 Buckets plural resource has the correct properties.'
  describe aws_s3_buckets do
    it { should exist }
    its('count') { should be >= 1 }
    its('bucket_names') { should_not include 'not-there-hopefully' }
  end
end
#ec2



control "aws-vpcs-multi-region-status-check" do                             # A unique ID for this control.
  impact 1.0                                                                # The criticality, if this control fails.
  title 'Check AWS VPCs in all regions have status "available"'             # A human-readable title.
  aws_regions.region_names.each do |region|                                 # Loop over all available AWS regions
    aws_vpcs(aws_region: region).vpc_ids.each do |vpc|                      # Find all VPCs in a single AWS region
      describe aws_vpc(aws_region: region, vpc_id: vpc) do                  # The test itself.
        it { should exist }                                                 # Confirms AWS VPC exists
        it { should be_available }                                          # Confirms AWS VPC has status "available"
      end
    end
  end
end

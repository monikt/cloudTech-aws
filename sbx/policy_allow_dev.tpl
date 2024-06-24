{
 "Version" : "2012-10-17",
  "Statement" : [
    {
      "Action" :[
        "ec2:Describe*",
        "ec2:Search*",
        "ec2:Get*"
      ],
        "Effect"   : "Allow",
        "Resource" : "${ec2_arn}"
    },
    {
      "Action" :[
        "ec2:RebootInstances"
      ],
        "Effect"   : "Allow",
        "Resource" : "${ec2_arn}"
    }
  ]
}
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
        "ec2:RebootInstances",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:CreateSnapshot",
        "ec2:CreateHibernationTask"
      ],
        "Effect"   : "Allow",
        "Resource" : "${ec2_arn}"
    }
  ]
}
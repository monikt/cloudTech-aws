{
 "Version" : "2012-10-17",
  "Statement" : [
    {
      "Action" :[
        "ec2:*"
      ],
        "Effect"   : "Allow",
        "Resource" : "${ec2_arn}"
    }   
  ]
}
{
 "Version" : "2012-10-17",
  "Statement" : [
    {
      "Action" :[
        "s3:*"
      ],
        "Effect"   : "Allow",
        "Resource" : "${bucket_s3_arn}/*"
    }
   
  ]
}
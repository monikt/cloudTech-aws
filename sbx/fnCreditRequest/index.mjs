import { DynamoDB } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocument } from '@aws-sdk/lib-dynamodb';
import { SQSClient, SendMessageCommand } from "@aws-sdk/client-sqs";

const dynamo = DynamoDBDocument.from(new DynamoDB());
const client = new SQSClient({ region: "us-east-1" });


export const handler = async (event) => {
    event.status="inprocess"
    const data = {
        TableName: "CreditRequestTable",
        Item: event
    }
    
    const result = await dynamo.put(data);
    
    
    const message = {
        id: event.id
    } 
  
      
    if (event.processName=='TC_REQUEST') {
       const params = {
            QueueUrl: "https://sqs.us-east-1.amazonaws.com/654654318411/sqsTCLambdaValidation",
            MessageBody: JSON.stringify(message)
        };
       const command = new SendMessageCommand(params);
       const sqsResult = await client.send(command);
       console.log('Success', sqsResult.MessageId); 
    }
    
    
    
    if (event.processName=='CL_REQUEST') {
        
       const params = {
            QueueUrl: "https://sqs.us-east-1.amazonaws.com/654654318411/sqsCLLambdaValidation",
            MessageBody: JSON.stringify(message)
        };
       const command = new SendMessageCommand(params);
       const sqsResult = await client.send(command);
       console.log('Success', sqsResult.MessageId); 
        
    }
    
      
      
    return result;
};



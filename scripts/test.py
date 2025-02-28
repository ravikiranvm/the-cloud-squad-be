import boto3, random, json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('SAAQuestionBank')

def lambda_handler(event, context):

    resource = event.get('resource')


    
    if resource == '/saa-questions':
        # Generate 10 random unique questions from the given range to throw at the test taker
        # Use walrus operator 
        required_question_ids = random.sample(range(1, 107), 1)
        questions = {
            question_id : {
                'id': int(item.get('id')),
                'question': item.get('question'),
                'options': item.get('options'),
                'correctAnswer': int(item.get('correctAnswer')),
                'explanation': item.get('explanation')
            }
            for question_id in required_question_ids
            if (item := table.get_item(Key={'id' : question_id}).get('Item'))
        }    

        return {
            'statusCode': 200,
            'body' : json.dumps(questions)
        }
    



    elif resource == '/submit-test':
        score = 0

        body = event.get('body')
        testSubmitted = json.loads(body)
        
        for question in testSubmitted:
            response = table.get_item(Key={'id': question['id']}).get('Item')
            if int(response['correctAnswer']) == question['answer']:
                score += 1
        
        return {
            'statusCode' : 200,
            'body' : json.dumps({'score' : score})
        }
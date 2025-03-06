import boto3, random, json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('SAAQuestionBank')
user_table = dynamodb.Table('Scores')

def lambda_handler(event, context):

    route = event.get('routeKey')


    if route == 'GET /saa-questions':
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
    

    elif route == 'POST /submit-test':
        score = 0

        body = event.get('body')
        testSubmitted = json.loads(body)
        
        # Accepts an array of objects in this format
        # [{'id': 1, 'answer': 1}, {'id': 2, 'answer' : 0}]
        for question in testSubmitted:
            response = table.get_item(Key={'id': question['id']}).get('Item')
            if int(response['correctAnswer']) == question['answer']:
                score += 1
        
        return {
            'statusCode' : 200,
            'body' : json.dumps({'score' : score})
        }

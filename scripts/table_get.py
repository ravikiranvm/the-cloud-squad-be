import boto3, random, json, uuid, datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('SAAQuestionBank')
users_table = dynamodb.Table('Scores')

def lambda_handler(event, context):

    route = event.get('routeKey')

    if route == 'POST /create-user':
        api_body = json.loads(event.get('body'))

        #api_requestContext = event.get('requestContext')
        #user_ip = api_requestContext.get('http').get('sourceIp')

        user = api_body.get('user_name')

        # Create a session_id for each test score submission
        # session_id = uuid + timestamp
        session_id = str(uuid.uuid4()) + str(datetime.date.today())

        item = {
            "session_id" : session_id,
            "user_name" :user
        }

        users_table.put_item(Item=item)

        # Return a session id for the user and later use it to store the score

        return {
            'statusCode': 200,
            'body' : json.dumps(session_id)
        }


    elif route == 'GET /saa-questions':
        # Generate 10 random unique questions from the given range to throw at the test taker
        # Use walrus operator 
        required_question_ids = random.sample(range(1, 107), 5)
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

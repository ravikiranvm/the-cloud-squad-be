import boto3, random, json, uuid, datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('SAAQuestionBank')
users_table = dynamodb.Table('Scores')
reviews_table = dynamodb.Table('Reviews')

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
        required_question_ids = random.sample(range(1, 351), 30)
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
        testSubmitted_full = json.loads(body)
        testSubmitted = testSubmitted_full.get('answers')
        session_id = testSubmitted_full.get('session_id')
        user_name = testSubmitted_full.get('user_name')
        
        # Accepts an array of objects in this format
        # [{'id': 1, 'answer': 1}, {'id': 2, 'answer' : 0}]
        for question in testSubmitted:
            response = table.get_item(Key={'id': question['id']}).get('Item')
            if int(response['correctAnswer']) == question['answer']:
                score += 1

        users_table.update_item(
            Key={
                "session_id": str(session_id),
                "user_name": str(user_name)
            },
            UpdateExpression="SET score = :score",
            ExpressionAttributeValues={
                ":score": score
            }
        )
        
        
        return {
            'statusCode' : 200,
            'body' : json.dumps({'score' : score})
        }
    
    elif route == 'GET /tests-taken':
        response = users_table.scan(Select='COUNT')
        total_tests_taken = response.get('Count')

        return {
            'statusCode' : 200,
            'body' : json.dumps({'total_tests_taken' : total_tests_taken})
        }
    
    elif route == 'POST /add-review':
        body = json.loads(event.get('body'))

        new_review = body.get('review')
        session_id = new_review.get('session_id')
        user_name = new_review.get('user_name')
        rating = new_review.get('rating')
        text_review = new_review.get('text_review')

        review_date = datetime.datetime.now().strftime("%Y-%m-%d")

        if text_review != '':
            item = {
                'session_id' : session_id,
                'date' : str(review_date),
                'user_name' : user_name,
                'rating' : rating,
                'text_review' : text_review  
            }
            reviews_table.put_item(Item=item)
            return {
                'statusCode': 200,
                'body' : json.dumps({'message' : 'Review added successfully'})
            }
        else:
            item = {
                'session_id' : session_id,
                'date' : str(review_date),
                'user_name' : user_name,
                'rating' : rating 
            }
            reviews_table.put_item(Item=item)
            return {
                'statusCode': 200,
                'body' : json.dumps({'message' : 'Rating added successfully'})
            }

import boto3, random, json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('SAAQuestionBank')

def lambda_handler(event, context):
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

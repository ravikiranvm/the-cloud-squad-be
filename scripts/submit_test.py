import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('SAAQuestionBank')

def submitTest(testSubmitted):
    score = 0
    
    for question in testSubmitted:
        response = table.get_item(Key={'id': question['id']}).get('Item')
        if int(response['correctAnswer']) == question['answer']:
            score += 1
    
    print(score)

if __name__ == '__main__':
    submitTest([{'id': 1, 'answer': 0}, {'id': 2, 'answer': 1}])

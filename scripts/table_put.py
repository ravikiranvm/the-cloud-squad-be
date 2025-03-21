import boto3, json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('SAAQuestionBank')

with open('saa5finalquestions.json', 'r') as f:
    data = json.load(f)

    for item in data['questions']:
        item = {
            "id" : item['id'],
            "question" : item['question'],
            "options" : item['options'],
            "correctAnswer" : item['correctAnswer'],
            "explanation" : item['explanation']
        }
        try:
            table.put_item(Item=item)
        except Exception as e:
            print(e)
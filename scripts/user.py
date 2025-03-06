import boto3, json, uuid, datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Scores')

def scores(event, context):

    api_body = json.loads(event.get('body'))

    api_requestContext = event.get('requestContext')
    user_ip = api_requestContext.get('http').get('sourceIp')

    user = api_body.get('user_name')

    # Create a session_id for each test score submission
    # session_id = uuid + timestamp
    session_id = str(uuid.uuid4()) + str(datetime.date.today())

    

    





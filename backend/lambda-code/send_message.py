import boto3
from datetime import datetime, timedelta
import json
import sys
from uuid import uuid4


TABLE_NAME = 'LUGChat'


dynamo = boto3.client('dynamodb')


def push_to_db(chatroom, user, timestamp, message):
    try:
        expires_on = (timestamp + timedelta(days=1)).timestamp()
        expires_on = str(expires_on).split('.')[0]
        item = {
            'Chatroom': {
                'S': chatroom
            },
            'User': {
                'S': user
            },
            'Timestamp': {
                'S': str(timestamp)
            },
            'Message': {
                'S': message
            },
            'ExpiresOn': {
                'N': expires_on
            },
            'ID': {
                'S': uuid4().hex
            }
        }
        dynamo.put_item(Item=item, TableName=TABLE_NAME)
        return True, 'Message pushed to DB'
    except Exception as e:
        print('Unable to push message to dynamo', file=sys.stderr)
        print(str(e), file=sys.stderr)
        return False, 'Error pushing message to DB'


def handler(event, context):
    params = event['pathParameters']
    status_code = 200
    res_body = {}
    try:
        chatroom = params['chatroom']
        body = json.loads(event['body'])
        user = body['user']
        timestamp = datetime.now()
        message = body['message']
        ok, msg = push_to_db(chatroom, user, timestamp, message)
        res_body['res'] = msg
        if not ok:
            status_code = 500
    except Exception as e:
        res_body['res'] = 'Generic error'
        status_code = 500
    return {
        'statusCode': status_code,
        'headers': {
            'Access-Control-Allow-Headers': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        'body': json.dumps(res_body),
        'isBase64Encoded': False
    }


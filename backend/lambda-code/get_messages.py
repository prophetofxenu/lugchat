import boto3
from datetime import datetime, timedelta
import json
import sys


TABLE_NAME = 'LUGChat'


dynamo = boto3.client('dynamodb')


def get_all_messages(chatroom):
    try:
        res = dynamo.query(
            ExpressionAttributeNames={ '#T': 'Timestamp', '#U': 'User' },
            TableName=TABLE_NAME,
            ExpressionAttributeValues={
                ':room': {
                    'S': chatroom
                }
            },
            KeyConditionExpression='Chatroom = :room',
            ProjectionExpression='ID, #T, #U, Message'
        )
        print(res)
        return True, res['Items']
    except Exception as e:
        print('Unable to pull all messages from dynamo', file=sys.stderr)
        print(f'chatroom: {chatroom}', file=sys.stderr)
        print(str(e), file=sys.stderr)
        return False, 'Unable to pull all messages from DB'


def get_since_one_sec_ago(chatroom):
    ts = datetime.now() - timedelta(seconds=1)
    ts = str(ts)[:19]
    print(ts)
    try:
        attribute_names = { '#T': 'Timestamp', '#U': 'User' }
        attribute_values = {
            ':room': {
                'S': chatroom
            },
            ':ts': {
                'S': ts
            }
        }
        key_expression = 'Chatroom = :room and begins_with(#T, :ts)'
        res = dynamo.query(
            TableName=TABLE_NAME,
            ExpressionAttributeNames=attribute_names,
            ExpressionAttributeValues=attribute_values,
            KeyConditionExpression=key_expression,
            ProjectionExpression='ID, #T, #U, Message'
        )
        return True, res['Items']
    except Exception as e:
        print('Unable to pull recent messages from dynamo', file=sys.stderr)
        print(f'chatroom: {chatroom}', file=sys.stderr)
        print(str(e), file=sys.stderr)
        return False, 'Unable to pull recent messages from DB'


def handler(event, context):
    path_params = event['pathParameters']
    chatroom = path_params['chatroom']
    query_params = event['queryStringParameters']
    if query_params is not None and 'all' in query_params.keys() and query_params['all'] == 'y':
        ok, result = get_all_messages(chatroom)
    else:
        ok, result = get_since_one_sec_ago(chatroom)
    res_body = { 'result': result }
    return {
        'statusCode': 200 if ok else 500,
        'headers': {
            'Access-Control-Allow-Headers': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        'body': json.dumps(res_body),
        'isBase64Encoded': False
    }


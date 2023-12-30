from unittest.mock import MagicMock
from src.main import lambda_handler  # Replace 'your_module_name' with the actual module name

def test_lambda_handler():
    # Mocking event and context
    event = {'key': 'value'}  # Replace this with your desired event
    context = MagicMock()

    # Call the lambda_handler function
    result = lambda_handler(event, context)

    # Assert the returned result
    assert result['statusCode'] == 200
    assert result['body'] == "Hello world!"
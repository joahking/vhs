## 0.3.0
* VHS.turn_off methods ejects all cassettes before turning off to avoid VCR
  from raising exceptions when there are active cassettes
* CLI command clean created to remove dirt cassettes
* Config options log_read and log_write added to separate both loggings

## 0.2.0
* requests matching changed to all [:method, :uri, :body, :params] to fix PUT
  and POST requests
* cassette CLI command list error fixed

## 0.1.0
* first working version without POST and PUT requests


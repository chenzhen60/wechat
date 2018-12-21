class TuringRobot
  class << self
    def call(sentence)
      data = {
      	"reqType":0,
          "perception": {
              "inputText": {
                  "text": sentence
              }
          },
          "userInfo": {
              "apiKey": TURING_ROBOT_API_KEY,
              "userId": TURING_ROBOT_USER_ID
          }
      }

      res = NetHelper.post(TURING_ROBOT_API_URL, data)
      json = JSON.parse(res)
      Rails.logger.info json
      # text = json['results'][0]['values']['text']
      text = json.to_s
    end
  end
end

const express = require('express');
const twilio = require('twilio');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

const accountSid = 'ACce59cee58f60ea21b174a018a5dd9e4e';
const authToken = '20faac30e3b371f73dcaca9bc872d9d9';
const client = twilio(accountSid, authToken);

const otpStore = {}; // Temporary storage for OTP

// Send OTP
app.post('/send-otp', async (req, res) => {
  const { phone } = req.body;
  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  otpStore[phone] = otp;

  try {
    await client.messages.create({
      body: `Your OTP is ${otp}`,
      from: '+1 279 207 1213',
      to: phone,
    });
    res.send({ success: true });
  } catch (e) {
    res.status(500).send({ success: false, error: e.message });
  }
});

// Verify OTP
app.post('/verify-otp', (req, res) => {
  const { phone, otp } = req.body;
  if (otpStore[phone] && otpStore[phone] === otp) {
    delete otpStore[phone];
    res.send({ success: true });
  } else {
    res.status(400).send({ success: false, error: 'Invalid OTP' });
  }
});

app.listen(3000, () => console.log('OTP server running on port 3000'));

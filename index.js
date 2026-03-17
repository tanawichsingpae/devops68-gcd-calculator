const express = require('express');
const app = express();

function gcd(a, b) {
  a = Math.abs(a);
  b = Math.abs(b);
  while (b !== 0) {
    [a, b] = [b, a % b];
  }
  return a;
}

app.get('/calculate', (req, res) => {
  const { a, b } = req.query;
  if (!a || !b) return res.status(400).json({ error: 'Missing a or b parameter' });
  
  const num1 = parseInt(a);
  const num2 = parseInt(b);
  if (isNaN(num1) || isNaN(num2)) return res.status(400).json({ error: 'a and b must be integers' });
  
  const result = gcd(num1, num2);
  res.json({ a: num1, b: num2, gcd: result });
});

app.listen(3017, () => console.log('GCD Calculator API on port 3017'));

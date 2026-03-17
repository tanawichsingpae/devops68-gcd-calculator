# GCD Calculator API

Calculate Greatest Common Divisor of two numbers.

## Endpoint

### GET `/calculate`

**Parameters:**
- `a` (required): First number
- `b` (required): Second number

**Example Request:**
```
http://localhost:3017/calculate?a=48&b=18
```

**Example Response:**
```json
{
  "a": 48,
  "b": 18,
  "gcd": 6
}
```

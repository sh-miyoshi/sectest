# API Server for MySQL Database

## Overview

This is a source code of API server for MySQL DB.

## APIs

### User API

| type   | value |
| ----   | ----  |
| Port   | 4567  |
| Method | POST  |
| Path   | /api  |

### Admin API

| type   | value       |
| ----   | ----        |
| Port   | 9000        |
| Method | GET         |
| Path   | /admin/info |

## How to Run

```bash
go build -o apiserver
export MYSQL_ADDR=127.0.0.1
./apiserver
```
# TrendSwap

A decentralized fashion item exchange protocol built on Stacks blockchain, enabling peer-to-peer trading of fashion items with secure ownership tracking and efficient listing management.

## Overview

TrendSwap revolutionizes fashion item exchanges by leveraging blockchain technology to create a trustless, secure platform for trading fashion items. The protocol enables users to list items with detailed metadata and manage their listings efficiently.

## Features

- Create detailed fashion item listings
- Secure ownership verification
- Listing management system
- Metadata support for item details
- Efficient data storage

## Contract Functions

### Public Functions

- `create-listing`: Create a new fashion item listing
- `cancel-listing`: Cancel an existing listing
- `get-listing`: Retrieve listing details
- `get-owner`: Get the owner of a listing

## Development

### Prerequisites

- Clarinet
- Stacks CLI

### Testing

```bash
clarinet check
clarinet test
```

### Deployment

1. Build the contract:
```bash
clarinet build
```

2. Deploy using Stacks CLI:
```bash
stx deploy_contract
```

## Security

The contract implements various security measures:
- Ownership verification
- Status validation
- Error handling

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
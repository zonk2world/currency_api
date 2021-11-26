## Getting started

This is a Currency Conversion API skeleton written in Ruby (None Rails environment).

## Software Requirements

- Ruby **2.5+**
- Sqlite3 **3.0+**

## How to install

### Using manual download ZIP

1.  Download zip
2.  Uncompress to your desired directory

### Install npm dependencies after installing (Git or manual download)

```bash
cd myproject
bundle install
```

## Avaialbe Routes

```sh
.
├── app.rb
├── router.rb
├── Gemfile
├── lib
│   └── api.rb
└── models
    └── project_model.rb
```

## How to run

### Running API server locally

```bash
ruby app.rb
```

### Creating new models

If you need to add more models to the project just create a new file in `/models/` and use them in the controllers.

### Creating new routes

If you need to add more routes to the project just create a new file in `/lib/` and add it in `/lib/api.rb` it will be loaded dynamically.

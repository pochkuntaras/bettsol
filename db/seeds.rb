include FactoryGirl::Syntax::Methods

DatabaseCleaner.strategy = :truncation, { except: %w(public.schema_migrations) }
DatabaseCleaner.clean

create_list :question_with_answers, 3

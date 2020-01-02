  # Number of processes to serve this storage (useful for read scaling)
  count = 4;

  # Backend ("sqlite" or "redis" - default "sqlite")
  backend = "redis";

  # sqlite: Where data file is stored (must be owned by rspamd user)
  # database = "${DBDIR}/fuzzy.db";

  # Hashes storage time (3 months)
  expire = 90d;

  # Synchronize updates to the storage each minute
  sync = 1min;

  allow_update = ["127.0.0.1"];

db.getSiblingDB("unifi").createUser({
  user: "unifi_user",
  pwd: "unifi_pass",
  roles: [
    { role: "dbOwner", db: "unifi" },
    { role: "dbOwner", db: "unifi_stat" }
  ]
});


class UserListDataModel {
    String avatar_url;
    String events_url;
    String followers_url;
    String following_url;
    String gists_url;
    String gravatar_id;
    String html_url;
    int id;
    String login;
    String node_id;
    String organizations_url;
    String received_events_url;
    String repos_url;
    bool site_admin;
    String starred_url;
    String subscriptions_url;
    String type;
    String url;
    bool status;

    UserListDataModel({this.status,this.avatar_url, this.events_url, this.followers_url, this.following_url, this.gists_url, this.gravatar_id, this.html_url, this.id, this.login, this.node_id, this.organizations_url, this.received_events_url, this.repos_url, this.site_admin, this.starred_url, this.subscriptions_url, this.type, this.url});

    factory UserListDataModel.fromJson(Map<String, dynamic> json) {
        return UserListDataModel(
            avatar_url: json['avatar_url'],
            events_url: json['events_url'],
            followers_url: json['followers_url'],
            following_url: json['following_url'],
            gists_url: json['gists_url'],
            gravatar_id: json['gravatar_id'],
            html_url: json['html_url'],
            id: json['id'],
            login: json['login'],
            node_id: json['node_id'],
            organizations_url: json['organizations_url'],
            received_events_url: json['received_events_url'],
            repos_url: json['repos_url'],
            site_admin: json['site_admin'],
            starred_url: json['starred_url'],
            subscriptions_url: json['subscriptions_url'],
            type: json['type'],
            url: json['url'],
            status:false
        );
    }
}
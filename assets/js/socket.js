import {Socket} from "phoenix";

let socket = new Socket("/socket", {params: {token: window.userToken}});

socket.connect();

const createSocket = () => {
  let el = document.getElementById('comments');
  if (el) {
    let topicId = el.dataset.topic_id;
    let channel = socket.channel(`comments:${topicId}`, {});
    channel.join()
      .receive("ok", response => {
        renderComments(response.comments);
      })
      .receive("error", resp => {
        console.log("Unable to join", resp)
      });

    channel.on(`comments:${topicId}:new`, renderComment)


    document.querySelector('button').addEventListener('click', () => {
      const content = document.querySelector('textarea').value;

      channel.push('comment:add', { content: content });
    })
  }
};

function renderComments(comments) {
  const renderedComments = comments.map(comment => {
    return commentTemplate(comment);
  })

  document.querySelector('.collection').innerHTML = renderedComments.join('');
};

function renderComment({comment}) {
  const renderedComment = commentTemplate(comment);

  document.querySelector('.collection').innerHTML += renderedComment;
}

function commentTemplate(comment) {
  let username = 'Anonymous';
  let avatar = 'https://cdn0.iconfinder.com/data/icons/unigrid-flat-human-vol-2/90/011_101_anonymous_anonym_hacker_vendetta_user_human_avatar-512.png';

  if (comment.user) {
    username = comment.user.username;
    avatar = comment.user.github_avatar;
  }

  return `
    <li class="collection-item">
      ${comment.body}
      <div class="right">
        <img src="${avatar}" alt="" class="avatar-large avatar-bordered"/>
        <p>${username}</p>
      </div>
    </li>
  `;
}

export { createSocket };

import {Socket} from "phoenix";

let socket = new Socket("/socket", {params: {token: window.userToken}});

socket.connect();

const createSocket = () => {
  let el = document.getElementById('comments');
  if (el) {
    let topicId = el.dataset.topic_id;
    let channel = socket.channel(`comments:${topicId}`, {});
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) });

    document.querySelector('button').addEventListener('click', () => {
      const content = document.querySelector('textarea').value;

      channel.push('comment:add', { content: content });
    })
  }
};

export { createSocket };

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class EffectController : MonoBehaviour
{
    [SerializeField] private List<Transform> TargetPositions = new List<Transform>();
    [SerializeField] private Material targetMat;
    [SerializeField] private float duration;
    int currentTargetPosIndex;
    Transform targetPosition;
    

    void Start()
    {
        currentTargetPosIndex = 0;
        targetPosition = TargetPositions[1];
    }



    void Update()
    {
        // if((targetPosition.position - transform.position).sqrMagnitude < 0.1)
        // {
        //     targetPosition = switchToNextTargetPos(currentTargetPosIndex);
        //     Debug.Log(currentTargetPosIndex);
        // }

        setNextTargetDistance(targetPosition);
    }

    void OnTriggerEnter(Collider other)
    {
        Debug.Log(other.name + " : currentTargetPosIndex " + currentTargetPosIndex);
        DOVirtual.DelayedCall(0.5f,() => 
        {
            targetPosition = switchToNextTargetPos(currentTargetPosIndex);  
        });
    }
    void OnTriggerExit(Collider other)
    {

    }

    private Transform switchToNextTargetPos (int currentPosIndex)
    {
        Debug.Log(currentPosIndex);
        if(currentPosIndex == TargetPositions.Count - 1)
        {
            currentTargetPosIndex = 0;
            Debug.Log("LastIndex!");
            return TargetPositions[0];
        }
        else
        {
            currentTargetPosIndex++;
            Debug.Log("Continue!");
            return TargetPositions[currentPosIndex + 1];
        }
    }

    private Vector4 setNextTargetDistance(Transform tartgetPos)
    {
        //エフェクトのシェーダーに次に移動する場所への自分との距離をセットする
        Vector4 nextTargetDistance = new Vector4(
            tartgetPos.position.x - transform.position.x,
            tartgetPos.position.y - transform.position.y,
            tartgetPos.position.z - transform.position.z,
            0);


        targetMat.SetVector("_TransferVector", nextTargetDistance);
        return nextTargetDistance;
    }

}
